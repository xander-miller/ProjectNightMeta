class UserGroup < ActiveRecord::Base
  belongs_to :user,  class_name: 'User',        foreign_key: :user_mu_id,  primary_key: :mu_id
  belongs_to :group, class_name: 'MeetupGroup', foreign_key: :group_mu_id, primary_key: :mu_id
end
