class GroupsController < ApplicationController

  # TODO remove GET /groups
  def index
    @groups = MeetupGroup.all.order("updated_at desc").limit(30)
    @title = "Meetup Groups"
  end

  # GET /groups/:id
  def show
    @group = MeetupGroup.find_by_muid_or_urlname(params[:id])

    # get upcoming event and RSVPs
    # build RSVP list
    @rsvps = []
    # build non-RSVP list
    @non_rsvps = @group.users

    respond_to do |format|
      format.html {
        unless @group
          redirect_to "/404"
          return
        end
        @title = "Group"
      }
      format.json {
        raise ActiveRecord::RecordNotFound unless @group
        render json: {group: @group, rsvps: @rsvps, non_rsvps: @non_rsvps}
      }
    end
  rescue ActiveRecord::RecordNotFound => e
    log_error_and_redirect_to(e, '/404')
  rescue Exception => e
    log_error_and_redirect_to(e, '/')
  end
end
