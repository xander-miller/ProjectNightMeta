class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.integer     :github_id
      t.boolean     :private,     :default => false
      t.boolean     :fork,        :default => false
      t.string      :name,        :null => false
      t.string      :full_name
      t.string      :description
      t.string      :language
      t.string      :homepage
      t.string      :html_url

      t.timestamps
    end
    add_index :projects, :name
  end
end
