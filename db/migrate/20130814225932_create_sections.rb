class CreateSections < ActiveRecord::Migration
  def change
    create_table :sections do |t|
      t.string :name
      t.string :key
	  t.references :site, :null => false
	  t.integer :limit, :default => 0
    end
    
   
    
  end
end
