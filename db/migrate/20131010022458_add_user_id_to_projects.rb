class AddUserIdToProjects < ActiveRecord::Migration
  def change
    # projet owner, not to be confused with github owner_id
    add_column :projects, :user_id,   :integer,   :null => false,  :default => 0
    add_index  :projects, :user_id

    User.all.each do | user |
      user.user_projects.each do | assoc |
        project = assoc.project
        project.user_id = user.id
        project.save
      end
    end
  end
end
