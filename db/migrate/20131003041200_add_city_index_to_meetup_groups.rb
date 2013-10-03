class AddCityIndexToMeetupGroups < ActiveRecord::Migration
  def change
    add_index :meetup_groups, :city
  end
end
