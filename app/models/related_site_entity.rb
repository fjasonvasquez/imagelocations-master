class RelatedSiteEntity < ActiveRecord::Base
  attr_accessor :enable
  
  attr_accessible :site_entity, :related_entity, :site_entity_id, :related_site_entity_id, :priority, :enable
  
  
  belongs_to :site_entity, :inverse_of => :related_site_entities
  belongs_to :related_entity, :class_name => 'SiteEntity', :foreign_key => "related_site_entity_id"
  
  #default_scope joins(:related_entity)
  default_scope order('related_site_entities.priority ASC')
end
