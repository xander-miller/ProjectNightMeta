class GroupsController < ApplicationController

  # GET /groups
  def index
    @groups = MeetupGroup.all.order("updated_at desc").limit(30)
    @title = "Meetup Groups"
  end

  # GET /groups/:id
  def show
    @group = MeetupGroup.find_by_muid_or_urlname(params[:id])
    redirect_to "/404" unless @group
  end

end
