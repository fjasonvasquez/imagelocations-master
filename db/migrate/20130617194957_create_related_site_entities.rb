class CreateRelatedSiteEntities < ActiveRecord::Migration
  def change
    create_table :related_site_entities do |t|
	  t.references :site_entity
	  t.integer :related_site_entity_id
	  t.integer :priority, :default => 0
      t.timestamps
    end
  end
end
