class SessionsController < ApplicationController

  # GET /login
  def index
    @title = "Welcome"
  end

  # GET /auth/:provider/callback
  def create
    hash = omniauth_hash
    first_time = false == User.exists?(["provider=? and mu_id=?",
      hash["provider"], hash["extra"]["raw_info"]["id"]])

    user = User.find_or_create_from_auth_hash(hash)
    session[:mu_id] = user.mu_id
    session[:mu_name] = user.mu_name

    if first_time
      redirect_to "/account?new=true"
    else
      redirect_to "/"
    end
  end

  # GET /signout
  def signout
    session[:mu_id] = nil
    session[:mu_name] = nil

    redirect_to "/"
  end


  protected
    def omniauth_hash
      request.env['omniauth.auth']
    end
end
