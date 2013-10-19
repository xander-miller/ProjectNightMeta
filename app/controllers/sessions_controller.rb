class SessionsController < ApplicationController

  # GET /signin
  def index
    @title = "Welcome"
  end

  # GET /auth/:provider/callback
  def create
    new_path = "/"

    if 'meetup' == params[:provider]
      user = create_meetup
      if user.should_sync
        new_path = "/user/groups"
      end
    elsif 'github' == params[:provider]
      create_github
      new_path = "/user/projects"
    else
      flash[:alert] = "Cannot accept authorization from #{params[:provider]}"
      redirect_to "/signin"
      return
    end

    redirect_to new_path

    rescue Exception => e
      log_error_and_redirect_to(e, '/signin')
  end

  # GET /user/signout
  def signout
    clear_session
    redirect_to "/"
  end


  protected
    def omniauth_hash
      request.env['omniauth.auth']
    end

    def create_meetup
      user = nil
      User.transaction do
        user = User.find_or_create_from_meetup(omniauth_hash)
      end
      session[:mu_uid] = user.uid
      session[:mu_name] = user.mu_name
      session[:provider] = user.provider
      # set location if needed
      if session[:ip_city].blank?
        session[:ip_city] = user.city
        session[:ip_country] = user.country.upcase  # CA
      end
      user
    end

    def create_github
      unless current_user.github_access
        session[:first_github_sync] = true
      else
        session[:first_github_sync] = nil
      end

      Access.transaction do
        Access.find_or_create_from_auth_hash(current_user, omniauth_hash)
      end
      current_user
    end

end
