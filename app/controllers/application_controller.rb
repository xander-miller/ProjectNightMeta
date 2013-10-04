require 'ruby_meetup'

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  protected

    # before_filter for accessing user pages
    def check_authorized
      if session[:mu_id]
        current_user
        return true
      end
      redirect_to "/login"
    end

    def current_user
      @user = User.find_by_mu_id(session[:mu_id]) unless @user
      @user
    end

    def clear_session
      # instead of reset_session
      session[:mu_id] = nil
      session[:mu_name] = nil
    end

end
