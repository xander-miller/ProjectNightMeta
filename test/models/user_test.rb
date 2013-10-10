require 'test_helper'

class UserTest < ActiveSupport::TestCase
  fixtures :users

  test "a register new user" do
    h = new_user_hash
    h["uid"] = 999999

    user = User.register_with(h)

    assert_equal h["provider"], user.provider, "provider should match"
    assert_equal h["uid"], user.uid, "uid should match"

    raw_info = h["extra"]["raw_info"]
    assert_equal raw_info["name"], user.mu_name, "mu_name should match"
    assert_equal raw_info["link"], user.mu_link, "mu_link should match"
    assert_equal raw_info["city"], user.city, "city should match"
    assert_equal raw_info["country"], user.country, "country should match"

    photo = raw_info["photo"]
    assert_equal photo["photo_link"], user.mu_photo_link, "mu_photo_link should match"
    assert_equal photo["highres_link"], user.mu_highres_link, "mu_highres_link should match"
    assert_equal photo["thumb_link"], user.mu_thumb_link, "mu_thumb_link should match"
    assert_equal photo["photo_id"], user.mu_photo_id, "mu_photo_id should match"

    creds = h["credentials"]
    assert_equal creds["token"], user.authentication_token, "authentication_token should match"
    assert_equal creds["refresh_token"], user.mu_refresh_token, "mu_refresh_token should match"
    assert_equal creds["expires_at"], user.mu_expires_at, "mu_expires_at should match"
    assert_equal creds["expires"], user.mu_expires, "mu_expires should match"
  end

  test "save a registered user" do
    h = new_user_hash
    h["uid"] = 999999
    user = User.register_with(h)
    assert user.save!, "Should saved"
    users = User.where(["uid=?", user.uid])
    assert_equal 1, users.length, "Should be one row"
  end

  test "save duplicate user" do
    h = new_user_hash
    h["uid"] = 999999
    user = User.register_with(h)
    assert user.save!, "Should saved"
    users = User.where(["uid=?", user.uid])
    assert_equal 1, users.length, "Should be one row"

    exception = assert_raise(ActiveRecord::RecordInvalid) {User.register_with(h)}
    assert_equal "Validation failed: Uid has already been taken", exception.message

    users = User.where(["uid=?", user.uid])
    assert_equal 1, users.length, "Should be one row"
  end

  test "has many groups" do
    user = users(:joe)
    assert_equal 2, user.user_groups.length, "Should have 2 UserGroup associations"
    assert_equal UserGroup, user.user_groups.first.class, "Should be UserGroup class"
    assert_equal 2, user.groups.length, "Should have 2 MeetupGroup associations"
    assert_equal MeetupGroup, user.groups.first.class, "Should be MeetupGroup class"
  end

  test "validate presence of uid" do
    user = User.new
    exception = assert_raise(ActiveRecord::RecordInvalid) {user.save!}
    assert exception.message.index("Uid can't be blank")
  end

  test "validate presence of mu_name" do
    user = User.new
    user.uid = 94022
    exception = assert_raise(ActiveRecord::RecordInvalid) {user.save!}
    assert exception.message.index("Mu name can't be blank")
  end

  test "validate presence of mu_link" do
    user = User.new
    user.uid = 94022
    user.mu_name = "Jane"
    exception = assert_raise(ActiveRecord::RecordInvalid) {user.save!}
    assert exception.message.index("Mu link can't be blank")
  end

  test "validate presence of provider" do
    user = User.new
    user.uid = 94022
    user.mu_name = "Jane"
    user.provider = nil
    exception = assert_raise(ActiveRecord::RecordInvalid) {user.save!}
    assert exception.message.index("Provider can't be blank")
  end

  test "import user Meetup groups" do
    user = users(:joe)
    assert_equal 2, user.groups.length, "Should have 2 MeetupGroup associations"

    root_hash = new_group_hash
    grps = root_hash["results"][0..1]
    # 1 new group (mu_id 1523801)
    # 1 already imported group (mu_id 521325), user is already a member
    assert_equal 2, grps.length, "There should be 2 meetup groups in import payload"

    imported = []
    grps.each { | hash |
      MeetupGroup.transaction do
        grp = user.import_meetup_group(hash)
        imported << grp if grp
      end
    }
    assert_equal grps.length, imported.length, "Number imported should equal number in payload"

    user.reload
    assert_equal 3, user.groups.length, "Should have 3 (2 + 1 new) MeetupGroup associations"
  end

  test "has many projects" do
    user = users(:jane)
    assert_equal 1, user.projects.length, "Should own 1 Project"
  end

  test "import user Github projects" do
    user = users(:joe)

    root_array = new_github_project_array
    assert_equal 2, root_array.length, "Should be 2 projects in import payload"

    imported = []
    root_array.each { | hash |
      Project.transaction do
        prj = user.import_github_project(hash)
        imported << prj if prj
      end
    }
    assert_equal root_array.length, imported.length, "Number imported should equal number in payload"

    user.reload
    assert_equal 2, user.projects.length, "Should have 2 new Project associations"
  end

  test "has many accesses" do
    user = users(:jane)
    accesses = user.accesses
    assert_equal 1, accesses.length, "user has many accesses"
    assert_equal "github", accesses.first.provider, "first access provider is github"
  end

  test "has many collaborations" do
    user = users(:jane)
    assert_equal 1, user.collaborations.length, "Should have 1 Project collaborations"
  end

  test "has many visbible projects" do
    user = users(:jane)
    assert_equal 0, user.visible_projects.length, "Should have 0 projects"
    projects = user.projects
    projects.each do | project |
      project.visible = true
      project.save
    end
    user.reload
    assert_equal projects.length, user.visible_projects.length, "Should match visible projects"
  end

end
