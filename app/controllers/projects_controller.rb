class ProjectsController < ApplicationController

  # GET /projects/:id
  def show
    @project = Project.find params[:id]

    respond_to do |format|
      format.html {
        unless @project.visible
          redirect_to "/404"
          return
        end
        @maintainers = @project.maintainers
        @title = "Project"
      }
      format.json {
        raise ActiveRecord::RecordNotFound unless @project.visible
        render json: @project
      }
    end

  rescue ActiveRecord::RecordNotFound => e
    log_error_and_redirect_to(e, '/404')
  rescue Exception => e
    log_error_and_redirect_to(e, '/')
  end
end
