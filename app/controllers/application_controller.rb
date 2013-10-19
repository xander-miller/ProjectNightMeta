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
        ip = request.remote_ip == '127.0.0.1' ? '24.246.4.1' : request.remote_ip
        a = ip.split('.')
        a.pop
        a.push('1')

        client = GeoIpClient.new
        s = client.get_path('/' + a.join('.'))

        hash = ActiveSupport::JSON.decode(s)
        session[:ip_city] = hash["city"]
        session[:ip_region] = hash["region_code"]
        session[:ip_country] = hash["country_code"]

        logger.info "* location: #{session[:ip_city]}, #{session[:ip_region]}, #{session[:ip_country]}"
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
