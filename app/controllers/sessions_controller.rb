class SessionsController < ApplicationController

  # GET /login
  def index
    @title = "Welcome"
  end

  # GET /auth/:provider/callback
  def create
    hash = omniauth_hash
    user = User.find_or_create_from_auth_hash(hash)
    session[:mu_id] = user.mu_id
    session[:mu_name] = user.mu_name

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
end
