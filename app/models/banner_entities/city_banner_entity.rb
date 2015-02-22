class CityBannerEntity < BannerEntity	
	has_one :banner_entity_site_entity, :foreign_key => :banner_entity_id
	has_one :site_entity, :through => :banner_entity_site_entity
	has_one :city, :through => :site_entity, :source => :site_entitable, :source_type => 'City'
	
	def self.model_name
    	BannerEntity.model_name
    end
	def self.entity
  		City
  	end
  	
  	def name
		city.full_name unless city.nil?
	end
	
	def self.entity_association
  		:city
  	end
  
end