class UserProjectsController < ApplicationController
  before_filter :check_authorized

  # GET /user/projects
  def index
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
    @project = Project.find_by_id params[:id]
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
    project = Project.find params[:id]
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

    rescue Exception => e
      log_error_and_redirect_to(e, '/user/projects')
  end

  # DELETE /user/projects/:id
  def delete
    project = Project.find_by_id params[:id]
    unless project
      redirect_to "/404"
      return
    end
    raise "Cannot delete. GitHub project should be synced instead." if project.is_github

    Project.transaction do
      project.destroy!
    end

    respond_to do |format|
      format.html { redirect_to '/user/projects' }
      format.json { head :ok }
    end

    rescue Exception => e
      log_error_and_redirect_to(e, '/user/projects')
  end

  # PUT /user/projects/:id/toggle
  def toggle_visible
    project = Project.find params[:id]
    project.toggle(:visible)
    project.save!

    respond_to do |format|
      format.html { redirect_to '/user/projects' }
      format.json { render json: project }
    end

    rescue Exception => e
      log_error_and_redirect_to(e, '/user/projects')
  end


  private

    def project_params
      params.require(:project).permit(:full_name, :description, :language, :name)
    end
end
