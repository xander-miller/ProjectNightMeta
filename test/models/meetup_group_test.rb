require 'test_helper'

class MeetupGroupTest < ActiveSupport::TestCase
  test "a build new group" do
    root_hash = new_group_hash
    h = root_hash["results"].first

    group = MeetupGroup.build_with(h)

    assert_equal h["id"], group.mu_id, "Unexpected mu_id"
    assert_equal h["name"], group.mu_name, "Unexpected mu_name"
    assert_equal h["link"], group.mu_link, "Unexpected mu_link"
    assert_equal h["city"], group.city, "Unexpected city"
    assert_equal h["state"], group.state, "Unexpected state"
    assert_equal h["country"], group.country, "Unexpected country"
    assert_equal h["description"], group.description, "Unexpected description"
    assert_equal h["urlname"], group.urlname, "Unexpected urlname"
    assert_equal h["visibility"], group.visibility, "Unexpected visibility"
    assert_equal h["who"], group.who, "Unexpected who"

    organizer = h["organizer"]
    assert_equal organizer["member_id"], group.mu_organizer_id, "Unexpected mu_organizer_id"
    assert_equal organizer["name"], group.mu_organizer_name, "Unexpected mu_organizer_name"

    photo = h["group_photo"]
    assert_equal photo["photo_link"], group.mu_photo_link, "Unexpected mu_photo_link"
    assert_equal photo["highres_link"], group.mu_highres_link, "Unexpected mu_highres_link"
    assert_equal photo["thumb_link"], group.mu_thumb_link, "Unexpected mu_thumb_link"
    assert_equal photo["photo_id"], group.mu_photo_id, "Unexpected mu_photo_id"
  end

  test "save a built group" do
    root_hash = new_group_hash
    h = root_hash["results"].first

    group = MeetupGroup.build_with(h)
    assert group.save!, "Should saved"
    groups = MeetupGroup.where(["mu_id=?", group.mu_id])
    assert_equal 1, groups.length, "Should be one row"
  end

  test "save duplicate group" do
    root_hash = new_group_hash
    h = root_hash["results"].first

    group = MeetupGroup.build_with(h)
    assert group.save!, "Should saved"
    groups = MeetupGroup.where(["mu_id=?", group.mu_id])
    assert_equal 1, groups.length, "Should be one row"

    group = MeetupGroup.build_with(h)
    exception = assert_raise(ActiveRecord::RecordInvalid) {group.save!}
    assert_equal "Validation failed: Mu has already been taken", exception.message

    groups = MeetupGroup.where(["mu_id=?", group.mu_id])
    assert_equal 1, groups.length, "Should be one row"
  end

end
