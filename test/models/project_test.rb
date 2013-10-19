require 'test_helper'

class ProjectTest < ActiveSupport::TestCase

  test "a build new project" do
    root_array = new_github_project_array
    h = root_array.first

    project = Project.build_with(h)

    assert_equal h["id"], project.github_id, "github_id should match"
    assert_equal h["owner"]["id"], project.owner_id, "owner_id should match"
    assert_equal h["private"], project.private, "private should match"
    assert_equal h["fork"], project.fork, "fork should match"
    assert_equal h["name"], project.name, "name should match"
    assert_equal h["full_name"], project.full_name, "full_name should match"
    assert_equal h["description"], project.description, "description should match"
    assert_equal h["language"], project.language, "language should match"
    assert_equal h["homepage"], project.homepage, "homepage should match"
    assert_equal h["html_url"], project.html_url, "html_url should match"
    created_at = Time.zone.parse(h["created_at"])
    assert_equal created_at, project.created_at, "created_at should match"

    assert_equal false, project.visible, "not visible by default"
  end

  test "validate presence of full_name" do
    project = Project.new
    exception = assert_raise(ActiveRecord::RecordInvalid) {project.save!}
    assert exception.message.index("Full name can't be blank")
  end

  test "save a built project" do
    root_array = new_github_project_array
    h = root_array.first

    project = Project.build_with(h)
    assert project.save!, "Should saved"
    projects = Project.where(["github_id=?", project.github_id])
    assert_equal 1, projects.length, "Should be one row"
  end

  test "save duplicate project" do
    root_array = new_github_project_array
    h = root_array.first

    project = Project.build_with(h)
    assert project.save!, "Should saved"
    projects = Project.where(["github_id=?", project.github_id])
    assert_equal 1, projects.length, "Should be one row"

    project = Project.build_with(h)
    assert project.save!, "Should saved - duplicate is allowed"

    projects = Project.where(["github_id=?", project.github_id])
    assert_equal 2, projects.length, "Should be two rows"
  end

  test "has contributors" do
    project = projects(:jane_blog)
    contributors = project.contributors
    assert_equal 2, contributors.length, "Should have 2 contributor"
    user = users(:jane)
    assert_equal user, contributors.first, "Contributor is Jane"
  end

  test "has maintainers" do
    project = projects(:jane_blog)
    maintainers = project.maintainers
    assert_equal 1, maintainers.length, "Should have 1 maintainer"
    user = users(:jane)
    assert_equal user, maintainers.first, "Maintainer is Jane"
    assert_equal user.city, project.city, "Should match city"
    assert_equal user.state, project.state, "Should match state"
    assert_equal user.country, project.country, "Should match country"
  end

  test "add contributor" do
    project = projects(:jane_blog)
    user = users(:joe)
    project.add_contributor(user)
    assert user.contributor_of?(project), "Joe should be a contributor"
    contributors = project.contributors
    assert_equal 3, contributors.length, "Should have 3 contributors"
  end

  test "remove contributor" do
    project = projects(:jane_blog)
    user = users(:joe)
    project.add_contributor(user)
    assert user.contributor_of?(project), "Joe should be a contributor"
    project.remove(user)
    project.reload
    assert_equal false, user.contributor_of?(project), "Joe should Not be a contributor"
    contributors = project.contributors
    assert_equal 2, contributors.length, "Should have 2 contributor"
  end

  test "destroy project" do
    project = projects(:jane_blog)
    contributors = project.contributors
    assert_equal 2, contributors.length, "Should have 2 contributor"
    project_id = project.id
    assert project.destroy, "Should destroy"
    project = Project.find_by_id project_id
    assert_equal nil, project, "Should be nil"
    assocs = UserProject.where(project_id: project_id)
    assert_equal 0, assocs.length, "Should be empty results"
  end
end
