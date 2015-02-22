class CreatePhotographers < ActiveRecord::Migration
  def change
    create_table :photographers do |t|
	  t.string :name
      t.timestamps
    end
    
    add_index :photographers, [:name], :unique => true
  end
end
