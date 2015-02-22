class AddPhotographerToAsset < ActiveRecord::Migration
  def change
	  add_column :assets, :photographer_id, :integer, :default => 0
  end
end
