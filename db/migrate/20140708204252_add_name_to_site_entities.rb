class AddNameToSiteEntities < ActiveRecord::Migration
  def change
  	add_column :site_entities, :entity_title, :string, :after => :priority, :default => "", :null => false
  end
end
