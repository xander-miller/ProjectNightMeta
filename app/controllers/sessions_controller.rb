class SessionsController < ApplicationController

  # GET /login
  def index
    @title = "Welcome"
  end

  # GET /auth/:provider/callback
  def create
    user = User.find_or_create_from_auth_hash(omniauth_hash)
    session[:mu_id] = user.mu_id
    session[:mu_name] = user.mu_name

    redirect_to controller: 'home'
  end

  # GET /signout
  def signout
    session[:mu_id] = nil
    session[:mu_name] = nil

    redirect_to controller: 'home'
  end


  protected
    def omniauth_hash
      request.env['omniauth.auth']
    end
end
