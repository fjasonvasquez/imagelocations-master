class CreatePermits < ActiveRecord::Migration
  def change
    create_table :permits do |t|
	  t.string :name
	  t.string :logo
	  t.integer :locations_count, :default => 0
      t.timestamps
    end
  end
end
