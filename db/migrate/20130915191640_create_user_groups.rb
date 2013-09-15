class CreateUserGroups < ActiveRecord::Migration
  def change
    create_table :user_groups do |t|
      t.integer        :user_mu_id,     :null => false
      t.integer        :group_mu_id,    :null => false
      t.boolean        :show,           :default => true
      t.timestamps
    end
    add_index :user_groups, :user_mu_id
    add_index :user_groups, :group_mu_id
  end
end
