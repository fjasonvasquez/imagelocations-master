class AddHeightAndWidthToAssets < ActiveRecord::Migration
  
  def up
  	add_column :assets, :height, :integer, :default => 0, :after => :file_size
  	add_column :assets, :width, :integer, :default => 0, :after => :height
  	
  	add_column :asset_versions, :height, :integer, :default => 0, :after => :asset_size_id
  	add_column :asset_versions, :width, :integer, :default => 0, :after => :height
  end
  
  def down
  	remove_column :assets, :height, :integer
  	remove_column :assets, :width, :integer
  	
  	remove_column :asset_versions, :height, :integer
  	remove_column :asset_versions, :width, :integer
  end
  
end
