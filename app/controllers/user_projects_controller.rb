class UserProjectsController < ApplicationController
  before_action :check_authorized

  # GET /user/projects
  def index
    if session[:first_github_sync]
      sync and return
    end

    if session[:manage_contributor_id]
      @contributor = User.find_by_id session[:manage_contributor_id]
    end

    @title = "My Projects"
  end

  # GET /user/projects/new
  def new
    @project = Project.new
    @title = "New Project"
  end

  # POST /user/projects
  def create
    project = Project.new
    Project.transaction do
      project.update(project_params)
      project.name = project.full_name
      project.save!
      project.add_maintainer(current_user)
    end

    respond_to do |format|
      format.html { redirect_to '/user/projects' }
      format.json { render json: project }
    end

  rescue Exception => e
    log_error_and_redirect_to(e, '/user/projects/new')
  end

  # GET /user/projects/:id/edit
  def edit
    @project = find_project
    unless @project
      redirect_to "/404"
      return
    end
    if @project.is_github
      flash[:alert] = "Should not edit a GitHub project."
      redirect_to "/user/projects"
      return
    end
    @title = "Edit Project"
  end

  # PUT /user/projects/:id
  def update
    project = find_project
    raise ActiveRecord::RecordNotFound unless project
    raise "Cannot update. GitHub project should be synced instead." if project.is_github
    Project.transaction do
      project.update(project_params)
      project.name = project.full_name
      project.save!
    end

    respond_to do |format|
      format.html { redirect_to '/user/projects' }
      format.json { render json: project }
    end

  rescue ActiveRecord::RecordNotFound => e
    log_error_and_redirect_to(e, '/404')
  rescue Exception => e
    log_error_and_redirect_to(e, '/user/projects')
  end

  # DELETE /user/projects/:id
  def delete
    project = find_project
    raise ActiveRecord::RecordNotFound unless project
    raise "Cannot delete. GitHub project should be synced instead." if project.is_github

    Project.transaction do
      project.destroy!
    end

    respond_to do |format|
      format.html { redirect_to '/user/projects' }
      format.json { head :ok }
    end

  rescue ActiveRecord::RecordNotFound => e
    log_error_and_redirect_to(e, '/404')
  rescue Exception => e
    log_error_and_redirect_to(e, '/user/projects')
  end

  # PUT /user/projects/:id/toggle
  def toggle_visible
    project = find_project
    raise ActiveRecord::RecordNotFound unless project
    project.toggle(:visible)
    project.save!

    respond_to do |format|
      format.html { redirect_to '/user/projects' }
      format.json { render json: project }
    end

  rescue ActiveRecord::RecordNotFound => e
    log_error_and_redirect_to(e, '/404')
  rescue Exception => e
    log_error_and_redirect_to(e, '/user/projects')
  end

  # POST /user/projects/sync
  def sync
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
          project.destroy if project
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
  ensure
    session[:first_github_sync] = nil
  end

  # PUT /user/projects/:id/add/contributor
  def add_contributor
    unless session[:manage_contributor_id]
      flash[:notice] = "Nothing to do. No Contributor selected."
      redirect_to "/user/projects" and return
    end

    user = User.find_by_id(session[:manage_contributor_id])
    raise "Contributor not found." unless user
 
    project = find_project
    raise "Project not found." unless project

    Project.transaction do
      project.add_contributor(user)
    end

    flash[:notice] = "Contributor added to Project."
    redirect_to "/user/projects"

  rescue Exception => e
    log_error_and_redirect_to(e, "/user/projects")
  end

  # PUT /user/projects/:id/remove/contributor
  def remove_contributor
    unless session[:manage_contributor_id]
      flash[:notice] = "Nothing to do. No Contributor selected."
      redirect_to "/user/projects" and return
    end

    user = User.find_by_id(session[:manage_contributor_id])
    raise "Contributor not found." unless user
 
    project = find_project
    raise "Project not found." unless project

    Project.transaction do
      project.remove(user)
    end

    flash[:notice] = "Contributor remove from Project."
    redirect_to "/user/projects"

  rescue Exception => e
    log_error_and_redirect_to(e, "/user/projects")
  end


  private
    def project_params
      params.require(:project).permit(:full_name, :description, :language, :name)
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

    def find_project
      Project.where(id: params[:id], user_id: current_user.id).first
    end
end
