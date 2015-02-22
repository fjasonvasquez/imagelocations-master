class BannerEntity < ActiveRecord::Base
  
  class << self
	def new_with_cast(*attributes, &block)
		if (h = attributes.first).is_a?(Hash) && !h.nil? && (type = h[:type] || h['type']) && type.length > 0 && (klass = type.constantize) != self
		  raise "wtF hax!!"  unless klass <= self
		  return klass.new(*attributes, &block)
		end
		
		new_without_cast(*attributes, &block)
	end
	alias_method_chain :new, :cast

  end
  
  include StiLoader
  
  attr_accessible :id, :type, :site, :site_id, :priority, :section, :banner_entity_site_entities_attributes
  
  #belongs_to :site
  belongs_to :section
  has_one :site, :through => :section
  
  
  has_many :banner_entity_site_entities, :foreign_key => :banner_entity_id, :dependent => :destroy
  has_many :site_entities, :through => :banner_entity_site_entities, :foreign_key => :related_site_entity_id, :inverse_of => :banner_entity_site_entities 
  
  accepts_nested_attributes_for :banner_entity_site_entities, :allow_destroy => true
  
  scope :site, proc { |site| joins(:section).where(:sections => {:site_id => site}) }
  
  scope :by_section, proc { |key| joins(:section).where(:sections => {:key => key}) }
  
  scope :published, proc { 
  	joins(:banner_entity_site_entities)
  	includes(:site_entities)
  	.where("site_entities.status = ? OR (site_entities.id IS NULL AND banner_entities.type = ?)",SiteEntity.published_status,"CustomBannerEntity")
  }
  
  
  scope :region, -> region {}
  
  
  validates :type, :presence => {:message => 'You must select a type'}
  
  default_scope order("banner_entities.priority ASC")
  
  
  def can_input_banner?
  	_can = false
  	
  	_check = section.section_objects.find_by_object(self.class.name)
  	
  	unless _check.nil?
  		
  		_can = _check.allow_banner
  	end
  	_can  
  end
  
  
  def name
	
  end
		
  def entity
  	self.class.entity.name.underscore unless self.class.entity.nil?
  end
  
  def entity_object
  	self.send(entity.to_sym) if !entity.nil? && self.respond_to?(entity.to_sym)
  end
  
  def self.entity
  
  end
  def self.entity_association

  end
end
