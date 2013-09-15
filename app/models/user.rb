class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  #devise :database_authenticatable, :registerable,
  #       :recoverable, :rememberable, :trackable, :validatable
  #
  #devise :omniauthable # disabled for now

  validates_uniqueness_of :mu_id

  has_many :user_groups, class_name: 'UserGroup', foreign_key: :user_mu_id, primary_key: :mu_id
  has_many :groups, through: :user_groups, source: :group


  # class methods

  def self.register_with(omniauth_hash)
    h = omniauth_hash
    user = new()
    user.provider = h["provider"]
    user.uid = h["uid"]

    raw_info = h["extra"]["raw_info"]
    user.mu_id = raw_info["id"]
    user.mu_name = raw_info["name"]
    user.mu_link = raw_info["link"]
    user.city = raw_info["city"]
    user.country = raw_info["country"]

    photo = raw_info["photo"]
    user.mu_photo_link = photo["photo_link"]
    user.mu_highres_link = photo["highres_link"]
    user.mu_thumb_link = photo["thumb_link"]
    user.mu_photo_id = photo["photo_id"]

    creds = h["credentials"]
    user.authentication_token = creds["token"]
    user.mu_refresh_token = creds["refresh_token"]
    user.mu_expires_at = creds["expires_at"]
    user.mu_expires = creds["expires"]

    user
  end


  # instance methods

end
