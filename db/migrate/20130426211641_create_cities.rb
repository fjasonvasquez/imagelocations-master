class CreateCities < ActiveRecord::Migration
  def change
    create_table :cities do |t|
      t.string :name, :null => false
      t.references :state, :null => false
      t.string :logo
      t.float :latitude
      t.float :longitude
      t.string :timezone
      t.integer :locations_count, :default => 0
    end
  end
end
