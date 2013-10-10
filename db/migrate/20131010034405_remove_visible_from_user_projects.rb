class RemoveVisibleFromUserProjects < ActiveRecord::Migration
  def change
    remove_column :user_projects, :visible
  end
end
