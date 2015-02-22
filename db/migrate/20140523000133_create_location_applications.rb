class CreateLocationApplications < ActiveRecord::Migration
  def change
    create_table :location_applications do |t|
	  t.references :site, :null => false
	  t.references :user
	  t.string :status, :default => :pending
      t.timestamps
    end
  end
end
