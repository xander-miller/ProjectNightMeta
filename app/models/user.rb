class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:meetup]

	def self.find_for_meetup_oauth(auth, signed_in_resource=nil)
	  user = User.where(:provider => auth.provider, :uid => auth.uid).first
	  unless user
	    user = User.create(  provider: auth.provider,
	                         uid: auth.uid,
	                         email: "#{auth.uid}@#{auth.provider}",
	                         password: Devise.friendly_token[0,20] )
	  end
	  user
	end
end
