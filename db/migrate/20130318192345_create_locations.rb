class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      #t.string :name
      t.references :series
      t.references :permit
      t.integer :series_number, :default => 0
      t.string :address
      t.string :postcode
      t.references :city
      t.float :latitude
      t.float :longitude
      t.timestamps
    end
    
    add_index :locations, [:series_id, :series_number], :unique => true
  end
end
