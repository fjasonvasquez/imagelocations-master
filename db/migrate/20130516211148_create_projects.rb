class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
	  t.string :name
	  t.references :company, :default => 0
      t.timestamps
    end
    
    create_table :locations_projects, :id => false do |t|
    	t.references :locations
    	t.references :projects
    end
  end
end
