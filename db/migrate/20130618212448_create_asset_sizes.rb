class CreateAssetSizes < ActiveRecord::Migration
  def change
    create_table :asset_sizes do |t|
	  t.references :site
	  t.string :key
	  t.string :process, :default => "resize_to_fill"
	  t.integer :height
	  t.integer :width
    end
  end
end
