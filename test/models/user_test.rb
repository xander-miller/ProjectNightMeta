require 'test_helper'

class UserTest < ActiveSupport::TestCase
  fixtures :users

  test "a register new user" do
    h = new_user_hash

    user = User.register_with(h)

    assert_equal h["provider"], user.provider, "Unexpected provider"
    assert_equal h["uid"], user.uid, "Unexpected uid"

    raw_info = h["extra"]["raw_info"]
    assert_equal raw_info["id"], user.mu_id, "Unexpected mu_id"
    assert_equal raw_info["name"], user.mu_name, "Unexpected mu_name"
    assert_equal raw_info["link"], user.mu_link, "Unexpected mu_link"
    assert_equal raw_info["city"], user.city, "Unexpected city"
    assert_equal raw_info["country"], user.country, "Unexpected country"

    photo = raw_info["photo"]
    assert_equal photo["photo_link"], user.mu_photo_link, "Unexpected mu_photo_link"
    assert_equal photo["highres_link"], user.mu_highres_link, "Unexpected mu_highres_link"
    assert_equal photo["thumb_link"], user.mu_thumb_link, "Unexpected mu_thumb_link"
    assert_equal photo["photo_id"], user.mu_photo_id, "Unexpected mu_photo_id"

    creds = h["credentials"]
    assert_equal creds["token"], user.authentication_token, "Unexpected authentication_token"
    assert_equal creds["refresh_token"], user.mu_refresh_token, "Unexpected mu_refresh_token"
    assert_equal creds["expires_at"], user.mu_expires_at, "Unexpected mu_expires_at"
    assert_equal creds["expires"], user.mu_expires, "Unexpected mu_expires"

  end

  test "save a registered user" do
    h = new_user_hash
    user = User.register_with(h)
    assert user.save!, "Should saved"
    users = User.where(["mu_id=?", user.mu_id])
    assert_equal 1, users.length, "Should be one row"
  end

  test "save duplicate user" do
    h = new_user_hash
    user = User.register_with(h)
    assert user.save!, "Should saved"
    users = User.where(["mu_id=?", user.mu_id])
    assert_equal 1, users.length, "Should be one row"

    user = User.register_with(h)
    exception = assert_raise(ActiveRecord::RecordInvalid) {user.save!}
    assert_equal "Validation failed: Mu has already been taken", exception.message

    users = User.where(["mu_id=?", user.mu_id])
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

  test "validate presence of mu_id" do
    user = User.new
    user.uid = 94022
    exception = assert_raise(ActiveRecord::RecordInvalid) {user.save!}
    assert exception.message.index("Mu can't be blank")
  end

  test "validate presence of mu_name" do
    user = User.new
    user.uid = 94022
    user.mu_id = 4902
    exception = assert_raise(ActiveRecord::RecordInvalid) {user.save!}
    assert exception.message.index("Mu name can't be blank")
  end

  test "validate presence of mu_link" do
    user = User.new
    user.uid = 94022
    user.mu_id = 4902
    user.mu_name = "Jane"
    exception = assert_raise(ActiveRecord::RecordInvalid) {user.save!}
    assert exception.message.index("Mu link can't be blank")
  end

  test "validate presence of provider" do
    user = User.new
    user.uid = 94022
    user.mu_id = 4902
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
    User.transaction do
      imported = user.import_meetup_groups(grps)
    end
    assert_equal grps.length, imported.length, "Number imported should equal number in payload"

    user.reload
    assert_equal 3, user.groups.length, "Should have 3 (2 + 1 new) MeetupGroup associations"
  end

end
