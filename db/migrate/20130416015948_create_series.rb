class CreateSeries < ActiveRecord::Migration
  def change
    create_table :series do |t|
	  t.string :name
	  t.integer :locations_count, :default => 0
      t.timestamps
    end
    add_index :series, [:name], :unique => true, :name => 'index_name'
  end
end
