class AddWatermarkOverrideToAssetEntities < ActiveRecord::Migration
  def change
  	add_column :asset_entities, :watermark_override, :boolean, :default => nil
  end
end
