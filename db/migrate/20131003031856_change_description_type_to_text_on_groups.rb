class ChangeDescriptionTypeToTextOnGroups < ActiveRecord::Migration
  def change
    change_column :meetup_groups, :description, :text
  end
end
