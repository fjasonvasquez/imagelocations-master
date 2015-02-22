class CreateRegions < ActiveRecord::Migration
  def change
    create_table :regions do |t|
	  t.string :name
	  t.string :label
	  t.integer :weather_city_id
	  t.text :weather_forecast
      t.timestamps
    end
  end
end
