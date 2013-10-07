class UserGroupsController < ApplicationController
  before_filter :check_authorized

  # GET /user/groups
  def index
    @title = "My Meetup Groups"
  end

end
