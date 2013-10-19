class AddStateToProjects < ActiveRecord::Migration
  def change
    add_column :projects,  :state,     :string,  :default => 'ON'
    add_index  :projects,  :visible
    add_index  :projects,  :language
  end
end
