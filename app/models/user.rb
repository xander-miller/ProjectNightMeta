class User < ActiveRecord::Base

  validates_presence_of   :uid, :mu_name, :mu_link, :provider
  validates_uniqueness_of :uid, scope: :provider

  has_many :accesses, class_name: 'Access', foreign_key: :user_id, primary_key: :id

  has_many :user_groups, class_name: 'UserGroup', foreign_key: :user_mu_id, primary_key: :uid
  has_many :groups, through: :user_groups, source: :group

  has_many :user_projects, class_name: 'UserProject', foreign_key: :user_id, primary_key: :id
  has_many :projects, through: :user_projects, source: :project


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
