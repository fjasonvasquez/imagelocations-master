class TearsBannerEntity < BannerEntity
  has_many :banner_entity_site_entities, :foreign_key => :banner_entity_id, :dependent => :delete_all
  has_many :site_entities, :through => :banner_entity_site_entities, :foreign_key => :related_site_entity_id,:inverse_of => :banner_entity_site_entities
  has_many :tears, :through => :site_entities, :source => :site_entitable, :source_type => 'Tear'
  
  def name
  	[].tap { |o|
  		tears.find_each do |t|
  			o << t.name
  		end
  	}.join(", ")
  end
  
  def self.model_name
    BannerEntity.model_name
  end
  
  def self.entity
  	Tear
  end
  
  def self.entity_association
  	:tears
  end
end