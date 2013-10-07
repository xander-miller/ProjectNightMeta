class User < ActiveRecord::Base

  validates_presence_of   :uid, :mu_name, :mu_link, :provider
  validates_uniqueness_of :uid, scope: :provider

  has_many :accesses, class_name: 'Access', foreign_key: :user_id, primary_key: :id

  has_many :user_groups, class_name: 'UserGroup', foreign_key: :user_mu_id, primary_key: :uid
  has_many :groups, through: :user_groups, source: :group

  has_many :user_projects, class_name: 'UserProject', foreign_key: :user_id, primary_key: :id
  has_many :projects, through: :user_projects, source: :project

  has_many :visible_user_projects, -> { where('visible = true') },
    class_name: 'UserProject', foreign_key: :user_id, primary_key: :id
  has_many :visible_projects, through: :visible_user_projects, source: :project


  # class methods

  def self.find_or_create_from_meetup(omniauth_hash)
    h = omniauth_hash
    raise "Cannot create new user from this provider." unless "meetup" == h["provider"]
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
    if new_record?
      self.provider = h["provider"]
      self.uid = h["uid"]
      raw_info = h["extra"]["raw_info"]
      self.mu_name = raw_info["name"]
      self.mu_link = raw_info["link"]
      save! # need to create user first
    end
    access = Access.find_or_create_from_auth_hash(self, omniauth_hash)
  end

  def member_of?(group)
    UserGroup.has_entry?(self, group)
  end

  def import_meetup_group(hash)
    return nil unless hash["visibility"].downcase.index("public")
    group = MeetupGroup.import_with(hash)
    group.add(self)
    group
  end

  def contributor_of?(project)
    UserProject.has_entry?(self, project)
  end

  def import_github_project(hash)
    return nil if hash["private"]
    return nil unless hash["owner"]["id"] == github_access.uid
    project = Project.import_with(hash)
    project.add_maintainer(self)
    project
  end

  def should_sync
    user_groups.blank?
  end
  def should_sync_github
    github_access.nil?
  end

  def github_access
    access_by("github")
  end

  def meetup_access
    access_by("meetup")
  end


  protected
    def access_by(provider="meetup")
      accesses.find { | ea | ea.provider == provider }
    end

end
