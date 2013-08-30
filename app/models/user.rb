class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise 	:database_authenticatable, :registerable,
				  :recoverable, :rememberable, :trackable, :validatable,
				  :omniauthable, :omniauth_providers => [:meetup]

	validates_presence_of :uid
	validates_presence_of :provider

  def self.find_for_meetup_oauth(auth, signed_in_resource=nil)

  	user = User.where(:provider => auth.provider, :uid => auth.uid).first
	  # unless user
	  #   user = User.create(	name: auth.info.name,
	  #   										provider: auth.provider,
	  #                       uid: auth.uid,
	  #                       password: Devise.friendly_token[0,20] )
	  # end
	  user || User.new
	end

	def self.new_with_session(params, session)
		super.tap do |user|
			if data = session["devise.meetup_data"]
				user.name = data["name"]
				user.provider = data["provider"]
				user.uid = data["uid"]
				user.password = Devise.friendly_token[0,20]
			end
		end
	end
end
