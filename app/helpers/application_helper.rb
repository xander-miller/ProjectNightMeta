module ApplicationHelper
  def get_location
    @location = Location.new_session(session) unless @location
    @location
  end
end
