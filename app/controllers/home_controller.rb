class HomeController < ApplicationController

  def index
    @groups = MeetupGroup.all.order("updated_at desc").limit(30)
    @title = "Home"
  end

  def about
    @title = "About"
  end

end
