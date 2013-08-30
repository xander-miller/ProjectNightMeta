class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
	def meetup

    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.find_for_meetup_oauth(request.env["omniauth.auth"], current_user)

    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => "Meetup") if is_navigational_format?
    else
    	session["devise.meetup_data"] = {}
    	session["devise.meetup_data"]["uid"] = request.env["omniauth.auth"]["uid"]
    	session["devise.meetup_data"]["name"] = request.env["omniauth.auth"]["info"]["name"]
    	session["devise.meetup_data"]["provider"] = request.env["omniauth.auth"]["provider"]
    	redirect_to new_user_registration_url, flash: { info: "Success! Please provide email address to complete the registration." }
    end
  end

  def failure
  	redirect_to root_url, :alert => "Authentication error"
  end
end

