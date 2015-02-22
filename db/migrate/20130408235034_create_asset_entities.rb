class CreateAssetEntities < ActiveRecord::Migration
  def change
    create_table :asset_entities do |t|
      t.references :site_entity, :null => false
      #t.belongs_to :asset_entitable, :polymorphic => true
      
      #t.integer :site_id, :default => 0
      t.references :asset, :null => false
    
      t.string :key
      t.text :meta
      t.integer :priority, :default => 0

      t.timestamps
    end
    #add_index :asset_entities, [:asset_entitable_id, :asset_entitable_type, :site_id, :asset_id, :asset_entity_key], :unique => true, :name => 'index_asset_entitable_site_id_asset_id_asset_entity_key'
    #add_index :asset_entities, [:asset_entitable_id, :asset_entitable_type, :site_id], :name => 'index_asset_entitable_site_id'
    #add_index :asset_entities, [:asset_entitable_id, :asset_entitable_type], :name => 'index_asset_entitable'
  end
end
