module ApplicationHelper
  def get_location
    @location = Location.new_session(session) unless @location
    @location
  end
  def get_user_name(user, project_maintainers)
    user.in_maintainers(project_maintainers) ? "*" + user.mu_name : user.mu_name
  end
end
