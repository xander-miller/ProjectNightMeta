class RemoveDeviseCreatedIndices < ActiveRecord::Migration
  def change
    remove_index :users, :reset_password_token
    remove_index :users, :email
  end
end
