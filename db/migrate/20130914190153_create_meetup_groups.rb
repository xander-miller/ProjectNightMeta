class CreateMeetupGroups < ActiveRecord::Migration
  def change
    create_table :meetup_groups do |t|
      t.integer     :mu_id,         :null => false
      t.string      :mu_name,       :null => false
      t.string      :mu_link,       :null => false
      t.string      :mu_photo_link
      t.string      :mu_highres_link
      t.string      :mu_thumb_link
      t.integer     :mu_photo_id
      t.integer     :mu_organizer_id
      t.string      :mu_organizer_name
      t.string      :city
      t.string      :state
      t.string      :country
      t.string      :description
      t.string      :urlname
      t.string      :visibility
      t.string      :who

      t.timestamps
    end
    add_index :meetup_groups, :mu_id
    add_index :meetup_groups, :mu_name

  end
end
