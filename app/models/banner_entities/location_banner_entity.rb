class LocationBannerEntity < BannerEntity
	
	has_one :banner_entity_site_entity, :foreign_key => :banner_entity_id
	has_one :site_entity, :through => :banner_entity_site_entity
	has_one :location, :through => :site_entity, :source => :site_entitable, :source_type => 'Location'
	
	
	scope :region, -> region {
		
		includes(:location => [:city, :state]).joins(RegionCondition.condition_join_statement).where(:regions => {:id => [region, nil]})
	}
	
	def name
		location.name unless location.nil?
	end
	
	def self.model_name
		 BannerEntity.model_name
	end
	
	def self.entity
  		Location
  	end
  	
  	def self.entity_association
  	:location
  end
end