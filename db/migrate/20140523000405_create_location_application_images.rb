class CreateLocationApplicationImages < ActiveRecord::Migration
  def change
    create_table :location_application_images do |t|
	  t.string :source
      t.timestamps
    end
  end
end
