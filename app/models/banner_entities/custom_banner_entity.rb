class CustomBannerEntity < BannerEntity
	attr_accessor :name
	
	has_one :banner_entity_site_entity, :foreign_key => :banner_entity_id
	
	
	attr_accessible :name, :banner_entity_site_entity_attributes
	
	
	
	accepts_nested_attributes_for :banner_entity_site_entity, :allow_destroy => true
	
	validates_presence_of :banner_entity_site_entity
	
	def name
		banner_entity_site_entity.options[:name] unless banner_entity_site_entity.nil? || banner_entity_site_entity.options[:name].nil?
	end
	
	def link
		link = banner_entity_site_entity.options[:link] unless banner_entity_site_entity.nil? || banner_entity_site_entity.options[:link].nil?
		link = link.blank? ? "#" : link
	end
	
	def name=(text)
		
		build_banner_entity_site_entity if banner_entity_site_entity.nil?
		
		banner_entity_site_entity.options[:name] = text
	end
	
	
	def self.model_name
		 BannerEntity.model_name
	end

  	
  	def self.entity_association
  		:custom
  end
end