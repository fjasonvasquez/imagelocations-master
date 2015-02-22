class CreateSiteEntities < ActiveRecord::Migration
  def change
    create_table :site_entities do |t|
	  t.belongs_to :site_entitable, :polymorphic => true, :null => false
	  t.integer :site_id, :default => 0
	  t.integer :priority, :default => 0
	  t.string :status, :default => SiteEntity::SITE_ENTITY_STATUSES[0]
      t.timestamps
    end
     add_index :site_entities, [:site_entitable_id, :site_entitable_type, :site_id], :unique => true, :name => 'index_site_entitable_site_id'
  end
end
