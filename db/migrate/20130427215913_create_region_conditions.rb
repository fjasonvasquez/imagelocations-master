class CreateRegionConditions < ActiveRecord::Migration
  def change
    create_table :region_conditions do |t|
      t.references :region
      t.string :type
      t.string :value
    end
    
    add_index :region_conditions, [:region_id, :type, :value], :unique => true
  end
end
