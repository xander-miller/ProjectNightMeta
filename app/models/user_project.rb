class UserProject < ActiveRecord::Base
  validates_presence_of   :user_id, :project_id

  belongs_to :user,    class_name: 'User',    foreign_key: :user_id,    primary_key: :id
  belongs_to :project, class_name: 'Project', foreign_key: :project_id, primary_key: :id


  # class methods

  def self.entry(user, project)
    where(["user_id=? and project_id=?", user.id, project.id]).first
  end

  def self.has_entry?(user, project)
    !entry(user, project).nil?
  end


end
