class CreateFieldObjects < ActiveRecord::Migration
  def change
    create_table :field_objects do |t|
	  t.references :field
	  t.string :object
    end
        
    add_index :field_objects, [:field_id, :object], :unique => true, :name => 'index_field_id_object'
  end
end
