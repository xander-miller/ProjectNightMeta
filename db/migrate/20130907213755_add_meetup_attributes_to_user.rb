class AddMeetupAttributesToUser < ActiveRecord::Migration
  def change

    change_table :users do |t|
      t.string      :provider,      :default => 'meetup'
      t.integer     :uid,           :null => false

      t.integer     :mu_id,         :null => false
      t.string      :mu_name,       :null => false
      t.string      :mu_link,       :null => false

      ## Token authenticatable - the meetup token
      t.string      :authentication_token

      t.string      :mu_refresh_token
      t.integer     :mu_expires_at
      t.boolean     :mu_expires,    :default => true

      t.string      :mu_photo_link
      t.string      :mu_highres_link
      t.string      :mu_thumb_link
      t.integer     :mu_photo_id

      t.string      :city
      t.string      :country

      t.index       :mu_id
      t.index       :mu_name
      t.index       :city
      t.index       :country
    end

  end
end
