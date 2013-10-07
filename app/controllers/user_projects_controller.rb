class UserProjectsController < ApplicationController
  before_filter :check_authorized

  # GET /user/projects
  def index
    @title = "My Projects"
  end

end
