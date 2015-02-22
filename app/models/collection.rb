class Collection < ActiveRecord::Base
  attr_accessible :name, :user, :site, :asset_entity_ids, :asset_entities
  
  belongs_to :user
  belongs_to :site
  
  has_and_belongs_to_many :asset_entities
  
  has_many :site_entities, :through => :asset_entities, :primary_key => :site_entity_id, :foreign_key => :id
  has_many :locations, :through => :site_entities, :source => :site_entitable, :source_type => 'Location'

  validates_presence_of :name
  
  def title
  	if name.blank? then Site.current.name else name end
  
  end

end
