class UserGroup < ActiveRecord::Base
  validates_presence_of   :user_mu_id, :group_mu_id

  belongs_to :user,  class_name: 'User',        foreign_key: :user_mu_id,  primary_key: :uid
  belongs_to :group, class_name: 'MeetupGroup', foreign_key: :group_mu_id, primary_key: :mu_id


  # class methods

  def self.has_entry?(user, group)
    exists?(["user_mu_id=? and group_mu_id=?", user.uid, group.mu_id])
  end


  # instance methods

end
