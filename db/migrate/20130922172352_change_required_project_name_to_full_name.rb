class ChangeRequiredProjectNameToFullName < ActiveRecord::Migration
  def change
    change_column :projects,  :name,      :string, :null => true
    change_column :projects,  :full_name, :string, :null => false
    remove_index  :projects,  :name
    add_index     :projects,  :full_name
  end
end
