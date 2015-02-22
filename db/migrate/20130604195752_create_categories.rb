class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
	  t.string :name
	  t.string :type
	  t.integer :locations_count, :default => 0
      t.timestamps
    end
    
    create_table :categories_locations, :id => false do |t|
      t.references :category, :location
    end
    add_index :categories_locations, [:category_id, :location_id], :unique => true
    
    
  end
end