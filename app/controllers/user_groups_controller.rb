class UserGroupsController < ApplicationController
  before_action :check_authorized

  # GET /user/groups
  def index
    @title = "My Meetup Groups"
  end

  # POST /user/groups/sync
  def sync
    hash = get_user_meetup_groups

    group_mu_ids = current_user.groups.collect { | group | group.mu_id }
    import_groups(hash["results"], group_mu_ids)

    # user has left these groups - remove UserGroup association
    unless group_mu_ids.blank?
      MeetupGroup.transaction do
        group_mu_ids.each do | mu_id |
          group = MeetupGroup.find_by_mu_id(mu_id)
          group.remove(current_user) if group
        end
      end
    end

    redirect_to "/user/groups"

  rescue Exception => e
    if e.message.index('401')
      clear_session
      flash[:notice] = "Your session may have expired. Please Sign in to resume access."
      redirect_to "/signin"
      return
    end
    flash[:alert] = e.message
    logger.info e.message
    logger.info e.backtrace.join("\n")
    redirect_to "/user/groups"
  end


  protected
    def get_user_meetup_groups
      client = RubyMeetup::AuthenticatedClient.new
      client.access_token = current_user.authentication_token
      json_s = client.get_path("/2/groups", {:member_id => current_user.uid})
      ActiveSupport::JSON.decode(json_s) # a hash
    end

    def import_groups(groups_a, group_mu_ids)
      count = 0
      fail_count = 0
      groups_a.each do | hash |
        begin
          MeetupGroup.transaction do
            group = current_user.import_meetup_group(hash)
            unless group.blank?
              count += 1
              group_mu_ids.delete(group.mu_id)
            end
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
