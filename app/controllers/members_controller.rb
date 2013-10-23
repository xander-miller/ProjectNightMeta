  class MembersController < ApplicationController
  before_action :check_authorized, only: [:manage]

  # GET /members/:id
  def show
    @member = User.find params[:id]

    respond_to do |format|
      format.html {
        unless @member
          redirect_to "/404"
          return
        end
        current_user if session[:mu_uid]
        @other_projects = @member.other_collaborations
        @title = "Profile"
      }
      format.json {
        raise ActiveRecord::RecordNotFound unless @member
        render json: @member
      }
    end

  rescue ActiveRecord::RecordNotFound => e
    log_error_and_redirect_to(e, '/404')
  rescue Exception => e
    log_error_and_redirect_to(e, '/')
  end

  # GET /members/:id/manage
  def manage
    member = User.find params[:id]
    if member == current_user
      session[:manage_contributor_id] = nil
    else
      session[:manage_contributor_id] = member.id
    end
    redirect_to "/user/projects"

  rescue ActiveRecord::RecordNotFound => e
    log_error_and_redirect_to(e, '/404')
  end
end
