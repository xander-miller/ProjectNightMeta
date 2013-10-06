class Access < ActiveRecord::Base

  validates_presence_of   :user_id, :uid, :provider, :raw_name
  validates_uniqueness_of :uid, scope: :provider

  belongs_to :user,    class_name: 'User',    foreign_key: :user_id,    primary_key: :id


  # class methods

  def self.grant_with(user, omniauth_hash)
    access = new()
    access.grant_or_refresh_with(user, omniauth_hash)
    access
  end


  # instance methods

  def grant_or_refresh_with(user, omniauth_hash)
    h = omniauth_hash
    if new_record?
      self.provider = h["provider"]
      self.uid = h["uid"]
      self.user_id = user.id
    else
      raise "Cannot refresh access. Provider is different." unless provider == h["provider"]
      raise "Cannot refresh access. Uid is different." unless uid == h["uid"]
    end

    if "meetup" == provider
      update_meetup(user, h)
    elsif "github" == provider
      update_github(user, h)
    else
      # do nothing
    end
  end


  protected
    def update_meetup(user, h)
      creds = h["credentials"]
      self.token = creds["token"]
      user.authentication_token = token
      self.refresh_token = creds["refresh_token"]
      self.expires_at = creds["expires_at"]
      self.expires = creds["expires"]

      raw_info = h["extra"]["raw_info"]
      user.mu_name = raw_info["name"]
      self.raw_name = user.mu_name
      user.mu_link = raw_info["link"]
      self.raw_link = user.mu_link
      user.city = raw_info["city"]
      user.country = raw_info["country"]

      photo = raw_info["photo"]
      user.mu_photo_link = photo["photo_link"]
      self.raw_photo_link = user.mu_photo_link
      user.mu_highres_link = photo["highres_link"]
      user.mu_thumb_link = photo["thumb_link"]
      user.mu_photo_id = photo["photo_id"]
    end

    def update_github(user, h)
      creds = h["credentials"]
      self.token = creds["token"]
      self.expires = creds["expires"]

      raw_info = h["extra"]["raw_info"]
      self.raw_name = raw_info["name"]
      self.raw_link = raw_info["html_url"]
      self.raw_photo_link = raw_info["avatar_url"]
    end

end
