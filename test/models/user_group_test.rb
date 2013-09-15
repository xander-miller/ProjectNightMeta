require 'test_helper'

class UserGroupTest < ActiveSupport::TestCase
  fixtures :user_groups, :users, :meetup_groups

  test "users groups pair" do
    user_group = user_groups(:joe_rug)
    assert_equal 21, user_group.user_mu_id, "meetup.com user id is set"
    assert_equal 421325, user_group.group_mu_id, "meetup.com group id is set"
    assert_equal true, user_group.show, "default is to make this group association visible"
  end

  test "users groups association" do
    user_group = user_groups(:joe_rug)
    user = users(:joe)
    group = meetup_groups(:rug)
    assert_equal user.mu_id, user_group.user.mu_id, "Should belong to User"
    assert_equal group.mu_id, user_group.group.mu_id, "Should belong to MeetupGroup"
  end

end
