class AddSlugToSiteEntities < ActiveRecord::Migration
  def change
  	add_column :site_entities, :slug, :string, :after => :priority
  	
  	add_index :site_entities, [:site_id, :slug], :unique => false
  	
  end
end
