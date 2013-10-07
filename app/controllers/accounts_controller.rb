class AccountsController < ApplicationController
  before_filter :check_authorized

  # GET /user/account
  def index
    @title = "Account Settings"
  end

  # POST /user/account/update/profile
  def update_profile
    current_user.email = params[:email]
    current_user.save!
    flash[:notice] = "Email updated"
    redirect_to "/user/account"
  end

  # POST /user/account/sync/groups
  def sync_groups
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
        flash[:notice] = "Your session may have expired. Please login to resume access."
        redirect_to "/login"
        return
      end
      flash[:alert] = e.message
      logger.info e.message
      logger.info e.backtrace.join("\n")
      redirect_to "/user/groups"
  end

  # POST /user/account/sync/projects
  def sync_projects
    access = current_user.github_access
    unless access
      redirect_to "/auth/github"
      return
    end

    client = GitHubV3API.new(access.token)
    repos = client.repos.list

    project_ids = current_user.projects.collect { | ea | ea.github_id }
    project_ids.compact!
    import_projects(repos, project_ids)

    # user may remove/make private these projects - remove UserProject association
    unless project_ids.blank?
      Project.transaction do
        project_ids.each do | gid |
          project = Project.find_by_github_id(gid)
          project.remove(current_user) if project
        end
      end
    end

    redirect_to "/user/projects"

    rescue Exception => e
      if e.message.index('401')
        redirect_to "/auth/github"
        return
      end
      flash[:alert] = e.message
      logger.info e.message
      logger.info e.backtrace.join("\n")
      redirect_to "/user/projects"
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

    def import_projects(project_a, project_ids)
      count = 0
      fail_count = 0
      project_a.each do | repo |
        begin
          Project.transaction do
            project = current_user.import_github_project(repo)
            unless project.blank?
              count += 1
              project_ids.delete(project.github_id)
            end
          end
        rescue Exception => e
          fail_count += 1
          logger.info "import_projects fail count: #{fail_count}"
          logger.info e.message
          logger.info e.backtrace.join("\n")
        end
      end

      if count > 0
        flash[:notice] = "Synced #{count} project(s)."
      end
      if fail_count > 0
        flash[:alert] = "Failed to sync #{fail_count} project(s)."
      end
    end

end
