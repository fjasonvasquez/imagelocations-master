class TearBannerEntity < BannerEntity	
	has_one :banner_entity_site_entity, :foreign_key => :banner_entity_id
	has_one :site_entity, :through => :banner_entity_site_entity
	has_one :tear, :through => :site_entity, :source => :site_entitable, :source_type => 'Tear'
	
	def self.model_name
    	BannerEntity.model_name
    end
	def self.entity
  		Tear
  	end
  	
  	def name
		tear.name unless tear.nil?
	end

  	
  	def self.entity_association
  	:tear
  end
end