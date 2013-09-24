class CreateUserProjects < ActiveRecord::Migration
  def change
    create_table :user_projects do |t|
      t.integer        :user_id,        :null     => false
      t.integer        :project_id,     :null     => false
      t.boolean        :is_maintainer,  :default  => false
      t.timestamps
    end
    add_index :user_projects, :user_id
    add_index :user_projects, :project_id
  end
end
