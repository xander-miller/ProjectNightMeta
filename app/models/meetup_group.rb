class MeetupGroup < ActiveRecord::Base

  validates_uniqueness_of :mu_id

  has_many :group_users, class_name: 'UserGroup', foreign_key: :group_mu_id, primary_key: :mu_id
  has_many :users, through: :group_users, source: :user


  # class methods

  def self.build_with(meetup_group_hash)
    h = meetup_group_hash
    group = new()
    group.mu_id = h["id"]
    group.mu_name = h["name"]
    group.mu_link = h["link"]
    group.city = h["city"]
    group.state = h["state"]
    group.country = h["country"]
    group.description = h["description"]
    group.urlname = h["urlname"]
    group.visibility = h["visibility"]
    group.who = h["who"]

    organizer = h["organizer"]
    group.mu_organizer_id = organizer["member_id"]
    group.mu_organizer_name = organizer["name"]

    photo = h["group_photo"]
    group.mu_photo_link = photo["photo_link"]
    group.mu_highres_link = photo["highres_link"]
    group.mu_thumb_link = photo["thumb_link"]
    group.mu_photo_id = photo["photo_id"]

    group
  end


  # instance methods

end
