class RemoveColumnsFromUsers < ActiveRecord::Migration
  def change
    remove_columns(:users,
      :encrypted_password,
      :reset_password_token,
      :reset_password_sent_at,
      :remember_created_at,
      :mu_id
      )
    remove_index  :users, :mu_name
    add_index     :users, :provider
    add_index     :users, :uid
  end
end
