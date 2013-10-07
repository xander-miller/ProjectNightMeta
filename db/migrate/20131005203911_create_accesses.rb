class CreateAccesses < ActiveRecord::Migration
  def change
    create_table :accesses do |t|
      t.integer     :user_id,       :null => false
      t.string      :provider,      :default => 'meetup'
      t.integer     :uid,           :null => false  # user id from provider

      t.string      :raw_name,      :null => false  # from raw_info hash
      t.string      :raw_link
      t.string      :raw_photo_link                 # from raw_info photo url

      t.string      :token                          # from credentials hash
      t.string      :refresh_token
      t.integer     :expires_at
      t.boolean     :expires,       :default => true

      t.timestamps
    end
    add_index :accesses, :user_id
    add_index :accesses, :provider
    add_index :accesses, :uid
  end
end
