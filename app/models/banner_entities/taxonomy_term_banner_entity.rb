class TaxonomyTermBannerEntity < BannerEntity	
	has_one :banner_entity_site_entity, :foreign_key => :banner_entity_id
	has_one :site_entity, :through => :banner_entity_site_entity
	has_one :taxonomy_term, :through => :site_entity, :source => :site_entitable, :source_type => 'TaxonomyTerm'
	
	def self.model_name
    	BannerEntity.model_name
    end
	def self.entity
  		TaxonomyTerm
  	end
end