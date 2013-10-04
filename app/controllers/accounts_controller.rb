class AccountsController < ApplicationController
  before_filter :check_authorized

  # GET /accounts
  def index
    @title = "Account Settings"
  end

  # POST /accounts/update/profile
  def update_profile
    current_user.email = params[:email]
    current_user.save!
    flash[:notice] = "Email updated"
    redirect_to "/account"
  end

  # POST /accounts/sync/groups
  def sync_groups
    client = RubyMeetup::AuthenticatedClient.new
    client.access_token = current_user.authentication_token
    json_s = client.get_path("/2/groups", {:member_id => current_user.mu_id})
    hash = ActiveSupport::JSON.decode(json_s)
    MeetupGroup.transaction do
      current_user.import_meetup_groups(hash["results"])
    end
    flash[:notice] = "Sync completed"
    redirect_to "/account"
    rescue Exception => e
      if e.message.index('401')
        clear_session
        flash[:notice] = "Your session may have expired. Please login to resume access."
        redirect_to "/login"
        return
      end
      flash[:alert] = e.message
      logger.info e.message
      redirect_to "/account"
  end

  # POST /accounts/sync/projects
  def sync_projects

    redirect_to "/account"
  end

end
