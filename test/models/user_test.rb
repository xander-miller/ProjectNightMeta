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

end
