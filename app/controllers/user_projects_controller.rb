class UserProjectsController < ApplicationController
  before_filter :check_authorized

  # GET /user/projects
  def index
    @title = "My Projects"
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
      logger.info e.message
      logger.info e.backtrace.join("\n")
      respond_to do | format |
        format.html {
          flash[:alert] = e.message
          redirect_to '/user/projects'
        }
        format.json {raise e}
      end
  end
end
