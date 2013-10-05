class SessionsController < ApplicationController

  # GET /login
  def index
    @title = "Welcome"
  end

  # GET /auth/:provider/callback
  def create
    if 'meetup' == params[:provider]
      user = create_meetup
    elsif 'github' == params[:provider]
      user = create_github
    else
      flash[:alert] = "Cannot login in with #{params[:provider]}"
      redirect_to "/login"
      return
    end

    if user.should_sync
      redirect_to "/account"
    else
      redirect_to "/"
    end
  end

  # GET /signout
  def signout
    clear_session
    redirect_to "/"
  end



  protected
    def omniauth_hash
      request.env['omniauth.auth']
    end

    def create_meetup
      user = User.find_or_create_from_auth_hash(omniauth_hash)
      session[:mu_id] = user.mu_id
      session[:mu_name] = user.mu_name
      user
    end

    def create_github
      puts omniauth_hash
      current_user
    end

end
