require 'ruby_meetup'

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  protected

    # before_action for accessing user pages
    def check_authorized
      if session[:mu_uid]
        current_user
        return true
      end
      redirect_to "/signin"
    end

    # before_action setting visitor location
    def set_location
      if session[:ip_city].nil?

        finder = LocationFinder.new
        finder.ipaddr = request.remote_ip
        @freegeoip = finder.lookup_freegeoip
        location = finder.lookup_meetup(@freegeoip)
        #location = LocationFinder.find_by_ip(request.remote_ip)

        session[:ip_city] = location.city
        session[:ip_region] = location.region
        session[:ip_country] = location.country

        logger.info "* location: #{location}"
      end
      true
    rescue Exception => e
      logger.info e.message
      session[:ip_city] = ''  # not able to set city base on IP
      true
    end

    def current_user
      unless @user
        conditions = {provider: session[:provider], uid: session[:mu_uid]}
        @user = User.find_by(conditions)
      end
      @user
    end

    def clear_session
      # instead of reset_session
      session[:mu_uid] = nil
      session[:mu_name] = nil
      session[:provider] = nil
      session[:manage_contributor_id] = nil
    end

    def log_error_and_redirect_to(error, url_path)
      logger.info error.message
      logger.info error.backtrace.join("\n")
      respond_to do | format |
        format.html {
          flash[:alert] = error.message
          redirect_to url_path
        }
        format.json {raise error}
      end
    end
end
