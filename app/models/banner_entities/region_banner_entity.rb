class RegionBannerEntity < BannerEntity	
	has_one :banner_entity_site_entity, :foreign_key => :banner_entity_id
	has_one :site_entity, :through => :banner_entity_site_entity
	has_one :region, :through => :site_entity, :source => :site_entitable, :source_type => 'Region'
	
	def self.model_name
    	BannerEntity.model_name
    end
	def self.entity
  		Region
  	end
  	
  	def name
		region.name unless region.nil?
	end
	
	def self.entity_association
  		:region
  	end
  
end