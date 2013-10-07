class Project < ActiveRecord::Base

  validates_presence_of   :full_name
  validates_uniqueness_of :full_name

  has_many :project_users, class_name: 'UserProject', foreign_key: :project_id, primary_key: :id
  has_many :contributors, through: :project_users, source: :user

  # class methods

  def self.build_with(github_repo_hash)
    project = new()
    project.refresh_with(github_repo_hash)

    project
  end

  def self.import_with(github_repo_hash)
    h = github_repo_hash
    if exists?(["github_id=?", h["id"]])
      project = find_by_github_id(h["id"])
      project.refresh_with(h)
    else
      project = build_with(h)
    end
    project.save!
    project
  end


  # instance methods

  def add_maintainer(user)
    assoc = UserProject.entry(user, self)
    if assoc
      if !assoc.is_maintainer
        # TODO - make user maintainer of project? User should already is!
      end
      return user
    end

    assoc = UserProject.new
    assoc.user = user
    assoc.project = self
    assoc.is_maintainer = true
    assoc.save!

    user
  end

  def remove(user)
    assoc = UserProject.entry(user, self)
    if assoc
      assoc.destroy
    end
  end

  def refresh_with(github_repo_hash)
    h = github_repo_hash

    self.github_id = h["id"]
    self.owner_id = h["owner"]["id"]
    self.private = h["private"]
    self.fork = h["fork"]
    self.name = h["name"]
    self.full_name = h["full_name"]
    self.description = h["description"]
    self.language = h["language"]
    self.homepage = h["homepage"]
    self.html_url = h["html_url"]
    self.created_at = h["created_at"]
  end

  def maintainers
    a = project_users.select { | each | each.is_maintainer }  
    a.collect { | each | each.user }
  end

end
