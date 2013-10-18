module GroupsHelper
  def format_event_datetime(object)
    s = object.strftime("%A, %B %d, %Y")
    s << " &nbsp; "
    s << object.strftime("%l:%M %p")
    s
  end
end
