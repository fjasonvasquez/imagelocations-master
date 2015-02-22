class CreateCollections < ActiveRecord::Migration
  def change
    create_table :collections do |t|
      t.references :user, :null => false
      t.references :site, :default => 0
      t.string :name
      t.timestamps
    end
    
     create_table :asset_entities_collections do |t|
      t.references :asset_entity, :null => false
      t.references :collection, :null => false
    end
  end
end
