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
    hash = get_user_meetup_groups

    group_mu_ids = current_user.groups.collect { | group | group.mu_id }
    import_groups(hash["results"], group_mu_ids)

    # user has left these groups - remove UserGroup association
    unless group_mu_ids.blank?
      MeetupGroup.transaction do
        group_mu_ids.each do | mu_id |
          group = MeetupGroup.find_by_mu_id(mu_id)
          group.remove(current_user)
        end
      end
    end

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
      logger.info e.backtrace.join("\n")
      redirect_to "/account"
  end

  # POST /accounts/sync/projects
  def sync_projects

    redirect_to "/account"
  end


  protected

    def get_user_meetup_groups
      client = RubyMeetup::AuthenticatedClient.new
      client.access_token = current_user.authentication_token
      json_s = client.get_path("/2/groups", {:member_id => current_user.mu_id})
      ActiveSupport::JSON.decode(json_s) # a hash
    end

    def import_groups(groups_a, group_mu_ids)
      count = 0
      fail_count = 0
      groups_a.each do | hash |
        begin
          MeetupGroup.transaction do
            sync_a = current_user.import_meetup_groups([hash])
            count += 1
            group_mu_ids.delete(sync_a.first.mu_id)
          end
        rescue Exception => e
          fail_count += 1
          logger.info "import_groups fail count: #{fail_count}"
          logger.info e.message
          logger.info e.backtrace.join("\n")
        end
      end

      if count > 0
        flash[:notice] = "Synced #{count} group(s)."
      end
      if fail_count > 0
        flash[:alert] = "Failed to sync #{fail_count} group(s)."
      end
    end

end
