class AddVisibleToUserProjects < ActiveRecord::Migration
  def change
    add_column :user_projects, :visible,   :boolean,   :default => false
  end
end
