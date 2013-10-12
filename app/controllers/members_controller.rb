class MembersController < ApplicationController

  # GET /members/:id
  def show
    @member = User.find params[:id]

    respond_to do |format|
      format.html {
        unless @member
          redirect_to "/404"
          return
        end
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
end
