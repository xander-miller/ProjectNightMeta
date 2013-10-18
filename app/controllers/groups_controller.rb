class GroupsController < ApplicationController

  # TODO remove GET /groups
  def index
    @groups = MeetupGroup.all.order("updated_at desc").limit(30)
    @title = "Meetup Groups"
  end

  # GET /groups/:id
  def show
    @group = MeetupGroup.find_by_muid_or_urlname(params[:id])
    raise ActiveRecord::RecordNotFound unless @group

    # get upcoming event and RSVPs
    @event = @group.next_event
    @confirms = []
    @unconfirms = []
    if @event
      @confirms = @event.confirmed_users
      @unconfirms = @event.unconfirmed_users
    else
      @unconfirms = @group.users
    end

    respond_to do |format|
      format.html {
        @title = "Group"
      }
      format.json {
        render json: {group: @group}
      }
    end
  rescue ActiveRecord::RecordNotFound => e
    log_error_and_redirect_to(e, '/404')
  rescue Exception => e
    log_error_and_redirect_to(e, '/')
  end
end
