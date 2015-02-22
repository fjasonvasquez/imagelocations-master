class AddSeriesToCategories < ActiveRecord::Migration
  def change
  	add_column :categories, :series_id, :integer
  	
  	add_index :categories, :series_id, :unique => false
  end
end
