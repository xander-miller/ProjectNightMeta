class HomeController < ApplicationController

  def index
    @projects = Project.where({visible: true}).order("updated_at desc").offset(0).limit(30)
    @title = "Home"
  end

  def about
    @title = "About"
  end

end
