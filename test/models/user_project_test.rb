require 'test_helper'

class UserProjectTest < ActiveSupport::TestCase
  fixtures :user_projects, :users, :projects

  test "users project pair" do
    user_project = user_projects(:jane_blog)
    assert_equal 20, user_project.user_id, "user id is set"
    assert_equal 1, user_project.project_id, "project id is set"
    assert_equal true, user_project.is_maintainer, "user is project maitainer"
  end

  test "users projects association" do
    user_project = user_projects(:jane_blog)
    user = users(:jane)
    project = projects(:jane_blog)
    assert_equal user.id, user_project.user.id, "Should belong to User"
    assert_equal project.id, user_project.project.id, "Should belong to Project"
  end

  test "validate presence of user_id" do
    user_project = UserProject.new
    exception = assert_raise(ActiveRecord::RecordInvalid) {user_project.save!}
    assert exception.message.index("User can't be blank")
  end

  test "validate presence of project_id" do
    user_project = UserProject.new
    user_project.user_id = 23425
    exception = assert_raise(ActiveRecord::RecordInvalid) {user_project.save!}
    assert exception.message.index("Project can't be blank")
  end

end
