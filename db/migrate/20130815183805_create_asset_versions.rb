class CreateAssetVersions < ActiveRecord::Migration
  def change
    create_table :asset_versions do |t|
    	t.references :asset, :null => false
    	t.references :asset_size, :null => false
    	t.boolean :processed, :default => false
    end
  end
end
