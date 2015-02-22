class CreateBannerEntitySiteEntities < ActiveRecord::Migration
  def change
    create_table :banner_entity_site_entities do |t|
      t.integer :banner_entity_id, :null => false
      t.string :banner
      t.integer :related_site_entity_id, :null => true, :default => 0
	  t.integer :priority, :default => 0
	  t.text :options
      t.timestamps
    end
  end
end
