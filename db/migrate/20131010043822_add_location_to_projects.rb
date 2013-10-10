class AddLocationToProjects < ActiveRecord::Migration
  def change
    add_column :projects,  :city,     :string
    add_column :projects,  :country,  :string
    add_index  :projects,  :city

    User.all.each do | user |
      user.projects.each do | project |
        project.city = user.city
        project.country = user.country
        project.save
      end
    end
  end
end
