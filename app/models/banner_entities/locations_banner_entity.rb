class LocationsBannerEntity < BannerEntity
  has_many :banner_entity_site_entities, :foreign_key => :banner_entity_id
  has_many :site_entities, :through => :banner_entity_site_entities, :foreign_key => :related_site_entity_id,:inverse_of => :banner_entity_site_entities
  has_many :locations, :through => :site_entities, :source => :site_entitable, :source_type => 'Location'
  
  
  scope :region, -> region {
		
		includes(:locations => [:city, :state]).joins(RegionCondition.condition_join_statement).where(:regions => {:id => [region, nil]})
	}
  
  def name
  	[].tap { |o|
  		locations.find_each do |l|
  			o << l.name
  		end
  	}.join(", ")
  end
  
  def self.model_name
    BannerEntity.model_name
  end
  
  def self.entity
  	Location
  end
  
  def self.entity_association
  	:locations
  end
end