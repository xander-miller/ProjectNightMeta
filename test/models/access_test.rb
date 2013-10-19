require 'test_helper'

class AccessTest < ActiveSupport::TestCase
  fixtures :users

  test "validate presence of user_id" do
    access = Access.new
    access.user_id = nil
    access.uid = 4902039
    access.provider = "foo"
    access.raw_name = "bar"
    exception = assert_raise(ActiveRecord::RecordInvalid) {access.save!}
    assert exception.message.index("User can't be blank")
  end

  test "validate presence of uid" do
    access = Access.new
    access.user_id = 99999
    access.uid = nil
    access.provider = "foo"
    access.raw_name = "bar"
    exception = assert_raise(ActiveRecord::RecordInvalid) {access.save!}
    assert exception.message.index("Uid can't be blank")
  end

  test "validate presence of provider" do
    access = Access.new
    access.user_id = 99999
    access.uid = 4902039
    access.provider = nil
    access.raw_name = "bar"
    exception = assert_raise(ActiveRecord::RecordInvalid) {access.save!}
    assert exception.message.index("Provider can't be blank")
  end

  test "validate presence of raw_name" do
    access = Access.new
    access.user_id = 99999
    access.uid = 4902039
    access.provider = "foo"
    access.raw_name = nil
    exception = assert_raise(ActiveRecord::RecordInvalid) {access.save!}
    assert exception.message.index("Raw name can't be blank")
  end

  test "new meetup access" do
    h = new_user_hash
    user = users(:joe)
    access = Access.grant_with(user, h)

    assert_equal "meetup", access.provider, "provider should be meetup"
    assert_equal h["provider"], access.provider, "provider should match"
    assert_equal h["uid"], access.uid, "uid should match"
    assert_equal user.id, access.user_id, "user_id should match"

    creds = h["credentials"]
    assert_equal creds["token"], access.token, "Unexpected token"
    assert_equal creds["refresh_token"], access.refresh_token, "Unexpected refresh_token"
    assert_equal creds["expires_at"], access.expires_at, "Unexpected expires_at"
    assert_equal creds["expires"], access.expires, "Unexpected expires"

    raw_info = h["extra"]["raw_info"]
    assert_equal raw_info["name"], access.raw_name, "raw_name should match"
    assert_equal raw_info["name"], user.mu_name, "mu_name should match - cached"
    assert_equal raw_info["link"], access.raw_link, "raw_link should match"
    assert_equal raw_info["link"], user.mu_link, "mu_link should match - cached"
    assert_equal raw_info["city"], user.city, "city should match"
    assert_equal raw_info["state"], user.state, "state should match"
    assert_equal raw_info["country"].upcase, user.country, "country should"

    photo = raw_info["photo"]
    assert_equal photo["photo_link"], access.raw_photo_link, "raw_photo_link should match"
    assert_equal photo["photo_link"], user.mu_photo_link, "mu_photo_link should match - cached"
    assert_equal photo["highres_link"], user.mu_highres_link, "mu_highres_link should match"
    assert_equal photo["thumb_link"], user.mu_thumb_link, "mu_thumb_link should match"
    assert_equal photo["photo_id"], user.mu_photo_id, "mu_photo_id should match"

  end

  test "save user meetup access" do
    h = new_user_hash
    user = users(:joe)
    access = Access.grant_with(user, h)
    assert access.save!, "access should save"
    assert user.save!, "user should save"
    assert_equal user.id, access.user_id, "access should belong to user"
  end

  test "belongs to user" do
    user = users(:jane)
    access = accesses(:jane_github)
    assert_equal user, access.user, "access should belong to user"
  end

  test "save duplicate access" do
    h = new_user_hash
    user = users(:joe)
    access = Access.grant_with(user, h)
    assert access.save!, "access should save"
    assert user.save!, "user should save"
    assert_equal user.id, access.user_id, "access should belong to user"

    access = Access.grant_with(user, h)
    exception = assert_raise(ActiveRecord::RecordInvalid) {access.save!}
    assert exception.message.index("Uid has already been taken")
  end

end
