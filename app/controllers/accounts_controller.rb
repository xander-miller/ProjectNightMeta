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
  rescue Exception => e
    log_error_and_redirect_to(e, '/user/account')
  end

  # DELETE /user/account/delete
  def delete
    User.transaction do
      current_user.delete_account
    end
    clear_session
    redirect_to "/"

  rescue Exception => e
    log_error_and_redirect_to(e, '/user/account')
  end
end
