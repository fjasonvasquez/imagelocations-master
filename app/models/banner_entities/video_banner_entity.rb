class VideoBannerEntity < BannerEntity
	
	has_one :banner_entity_site_entity, :foreign_key => :banner_entity_id
	has_one :site_entity, :through => :banner_entity_site_entity, :foreign_key => :related_site_entity_id,:inverse_of => :banner_entity_site_entities
	has_one :asset, :through => :site_entity, :source => :site_entitable, :source_type => 'Asset'
	
	attr_accessible :banner_entity_site_entity_attributes
	
	accepts_nested_attributes_for :banner_entity_site_entity, :allow_destroy => true
	
	def name
		asset.title unless asset.nil?
	end
	
	def self.model_name
		 BannerEntity.model_name
	end
	
	def self.entity
  		Asset
  	end
  	
  	def self.entity_association
  	:asset
  end
end