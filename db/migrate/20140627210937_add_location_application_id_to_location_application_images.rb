class AddLocationApplicationIdToLocationApplicationImages < ActiveRecord::Migration
  def change
  	add_column :location_application_images, :location_application_id, :integer, :after => :id, :null => false, :default => 0
  end
end
