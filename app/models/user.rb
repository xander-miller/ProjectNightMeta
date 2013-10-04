class User < ActiveRecord::Base

  validates_presence_of   :uid, :mu_id, :mu_name, :mu_link, :provider
  validates_uniqueness_of :mu_id

  has_many :user_groups, class_name: 'UserGroup', foreign_key: :user_mu_id, primary_key: :mu_id
  has_many :groups, through: :user_groups, source: :group

  has_many :user_projects, class_name: 'UserProject', foreign_key: :user_id, primary_key: :id
  has_many :projects, through: :user_projects, source: :project


  # class methods

  def self.find_or_create_from_auth_hash(omniauth_hash)
    h = omniauth_hash
    user = find_or_initialize_by({provider: h["provider"], uid: h["uid"]})
    user.refresh_with(h)
    user.save!
    user
  end

  def self.register_with(omniauth_hash)
    user = new()
    user.refresh_with(omniauth_hash)
    user
  end


  # instance methods

  def refresh_with(omniauth_hash)
    h = omniauth_hash
    self.provider = h["provider"] if provider.blank?
    self.uid = h["uid"]

    raw_info = h["extra"]["raw_info"]
    self.mu_id = raw_info["id"]
    self.mu_name = raw_info["name"]
    self.mu_link = raw_info["link"]
    self.city = raw_info["city"]
    self.country = raw_info["country"]

    photo = raw_info["photo"]
    self.mu_photo_link = photo["photo_link"]
    self.mu_highres_link = photo["highres_link"]
    self.mu_thumb_link = photo["thumb_link"]
    self.mu_photo_id = photo["photo_id"]

    creds = h["credentials"]
    self.authentication_token = creds["token"]
    self.mu_refresh_token = creds["refresh_token"]
    self.mu_expires_at = creds["expires_at"]
    self.mu_expires = creds["expires"]
  end

  def member_of?(group)
    UserGroup.has_entry?(self, group)
  end

  def import_meetup_groups(array)
    imported = []
    array.each { | hash |
      if hash["visibility"].downcase == "public"
        group = MeetupGroup.import_with(hash)
        group.add(self)
        imported.push(group)
      end
    }
    imported
  end

  def contributor_of?(project)
    UserProject.has_entry?(self, project)
  end

  def import_github_projects(array)
    imported = []
    array.each { | hash |
      project = Project.import_with(hash)
      project.add_maintainer(self)
      imported.push(project)
    }
    imported
  end

  def should_sync
    user_groups.blank?
  end

end
