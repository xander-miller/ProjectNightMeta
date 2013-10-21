module ApplicationHelper
  def get_location
    @location = Location.new_session(session) unless @location
    @location
  end
  def get_user_name(user, project_maintainers)
    user.in_maintainers(project_maintainers) ? "*" + user.mu_name : user.mu_name
  end
  def max_project_count(projects, limit=3)
    count = projects.length > 0 ? projects.length : 0
    count = count >= limit ? limit : count
    count
  end
end
