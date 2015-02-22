class CreateFieldEntities < ActiveRecord::Migration
  def change
    create_table :field_entities do |t|
	  t.references :site_entity
	  t.references :field
	  t.text :value
	  #t.belongs_to :field_entitable, :polymorphic => true
	  #t.integer :site_id, :default => 0
      t.timestamps
    end
    #add_index :field_entities, [:field_id, :field_entitable_id, :field_entitable_type, :site_id], :unique => true, :name => 'index_field_id_field_entitable_site_id'
  end
end
