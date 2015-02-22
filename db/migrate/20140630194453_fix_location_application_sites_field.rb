class FixLocationApplicationSitesField < ActiveRecord::Migration
  def change
  	add_column :location_applications, :listing, :text, :after => :usage
  end

  def down
  	remove_column :locations_applications, :listing
  end
end
