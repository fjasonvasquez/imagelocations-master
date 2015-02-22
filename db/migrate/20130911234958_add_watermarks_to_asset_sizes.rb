class AddWatermarksToAssetSizes < ActiveRecord::Migration
  def up
  	add_column :asset_sizes, :watermark, :boolean, :default => false
  end
  
  def down
  	remove_column :asset_sizes, :watermark, :boolean
  end
end
