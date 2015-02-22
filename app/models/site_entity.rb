class SiteEntity < ActiveRecord::Base
  
  attr_accessible :id, :site_entity, :site_entitable, :site_entitable_id, :site_entitable_type, :site, :site_id, :slug, :enable, :status, :priority, :asset_entities
  attr_accessible :entity_title
  
  attr_accessor :enable, :force_dup
  
  scope :site, proc { |site| where({:site_id => site }) }
  scope :type, proc { |type| where({:site_entitable_type => type }) }
  scope :slug, -> slug { where({ :slug => slug }) }
  
  scope :excluding_ids, lambda { |ids| where(['site_entities.id NOT IN (?)', ids]) if ids.any? }
  
  scope :published, proc { where(:status => self.published_status) }
  
  belongs_to :site_entitable, :polymorphic => true, :inverse_of => :site_entities, :touch => true
  belongs_to :site, :inverse_of => :site_entities
  
  has_many :taxonomy_term_entities, :dependent => :delete_all
  has_many :taxonomy_terms, :through => :taxonomy_term_entities
  has_many :taxonomies, :through => :taxonomy_terms
  
  has_many :asset_entities, :dependent => :delete_all, :order => :priority, :inverse_of => :site_entity
  has_many :assets, :through => :asset_entities
  
  has_many :images, :through => :asset_entities, :foreign_key => "asset_id"
  
    
  has_many :gallery_asset_entities, :class_name => "AssetEntity", :conditions => ["asset_entities.key = 'gallery'"]
  has_many :gallery_assets, :through => :gallery_asset_entities, :source => :asset
  
  has_one :cover_asset_entity, :class_name => "AssetEntity", :conditions => ["asset_entities.key = 'cover'"]
  has_one :cover_asset, :through => :cover_asset_entity, :source => :asset
  #has_one :cover_image, :through => :asset_entities, :foreign_key => "asset_id", :conditions => ["asset_entities.key = ?", "cover"], :source => "Image"
  
  
  has_many :related_site_entities, :dependent => :delete_all, :inverse_of => :site_entity
  has_many :related_entities, :through => :related_site_entities, :foreign_key => "related_site_entity_id", :class_name => "SiteEntity", :order => "related_site_entities.priority ASC"
  
  has_many :related_to_site_entities, :source => :related_site_entities, :foreign_key => "related_site_entity_id", :class_name => "RelatedSiteEntity", :dependent => :delete_all
  
  has_many :related_locations, :through => :related_entities, :source => :site_entitable, :source_type => 'Location', :inverse_of => :related_entities
  
  has_many :field_entities, :dependent => :delete_all

  has_many :banner_entity_site_entities, :foreign_key => :related_site_entity_id, :dependent => :delete_all, :inverse_of => :related_entity
  has_many :banner_entities, :through => :banner_entity_asset_entities
    
  attr_accessible :taxonomy_term_entities_attributes
  
  attr_accessible :related_locations_attributes, :related_locations_ids
  
  attr_accessible :field_entities_attributes
  attr_accessible :asset_entities_attributes
  attr_accessible :gallery_asset_entities_attributes
  attr_accessible :related_site_entities_attributes, :related_site_entity_ids
         
  accepts_nested_attributes_for :taxonomy_term_entities, allow_destroy: true
  accepts_nested_attributes_for :field_entities, allow_destroy: true
  
  accepts_nested_attributes_for :asset_entities, allow_destroy: true
  accepts_nested_attributes_for :gallery_asset_entities, allow_destroy: true
  
  
  accepts_nested_attributes_for :related_site_entities, allow_destroy: true
  accepts_nested_attributes_for :related_locations, allow_destroy: true
  
  SITE_ENTITY_STATUSES = %w{draft suspended published}
  
  validates :status, :inclusion => { :in => SITE_ENTITY_STATUSES }
  
  validates :slug, :allow_blank => true, :uniqueness => {:scope => [:site_entitable_type, :site_id]}
  
  delegate :name, :to => :site_entitable, :allow_nil => true
  
  delegate :default?, :to => :site
  
  
  before_validation :filter_slug
  
  
  
  
  def self.default_status
  	self.published_status	
  end
  
  def self.published_status
  	"published"
  
  end
  def self.search_by_location_name(string)
  
  	condition = ["%" + string.downcase.gsub(" ","%") + "%"]
  	adapter = ActiveRecord::Base.connection.instance_values["config"][:adapter].to_sym
  	
  	sql_string = (adapter == :mysql2) ?  "CONCAT(LOWER(series.name),' ',locations.series_number)" : "(lower(series.name) || ' ' || locations.series_number)"
  	
  	joins("INNER JOIN locations ON site_entities.site_entitable_id = locations.id")
  	.joins("INNER JOIN series ON locations.series_id = series.id")
  	.where("LOWER(series.name) LIKE ? OR #{sql_string} LIKE ?",condition,condition)
  	.order("series.name ASC, locations.series_number ASC")
  end
 
  def initialized_entity_assets(key = nil)
  	entity = needs_dup? ? entity_dup : self
  	
  	
  	[].tap do |o|
  		#ap asset_entities
  		entity.asset_entities.each do |f|
  
  			
  			o << f.tap {|f| f.id = nil if needs_dup?} if key.nil? || f.key == key 
  			
		end
	end
  	
  end
  
  def assets_by_keys(*keys)
  	ap keys
  
  end
  
  def published?
	 status == self.class.published_status
  end
	
  
  def entity_taxonomies
	 Taxonomy.where("object = ? OR object = 'all'", self.site_entitable_type).find(:all)
  end
  
  def unassociated_locations
  	excluded_ids = similar_location_ids
  	if site_entitable_type == "Location"
  		excluded_ids << site_entitable_id
  	end
  	Location.where("locations.id NOT IN(?)",excluded_ids)
  end
  
  
  def entity_fields
  	entity = needs_dup? ? entity_dup : self
  	
  	
  	[].tap do |o|
  		site_entitable.class.object_fields.find_each do |f|
  			
  			if fe = entity.field_entities.find { |fe| fe.field_id == f.id }
		  			o << fe.tap do |se| 
		  				se.id = nil if needs_dup?
		  				se.enable ||= true
		  			end
		  		else
		  			o << field_entities.new(:field => f)
		  		end
		  end
	end
  end
  
  def needs_dup?
  	(new_record? && !default? && site_entitable.respond_to?(:site_entities)) && !force_dup.nil?
  end
  
  def set_entity_dup(entity)
  	@dup_entity = entity
  end
  
  def entity_dup
  	@dup_entity ||= begin
  		site_entitable.site_entities.detect { |s| s.site.default? }
  	end
  end
  
  
  
  def build_and_save_default(delete_previous = false)
  	
  	#_default_entity = self.site_entitable.site_entities.detect?{ |s| s.site == Site.default()}
  	_default_entity = self.site_entitable.default_entity

  	if delete_previous
  		_default_entity.taxonomy_term_entities.delete_all		
  		_default_entity.asset_entities.delete_all
		_default_entity.field_entities.delete_all
		_default_entity.related_site_entities.delete_all
		
  	end
  	
  	_default_entity.priority = self.priority
  	_default_entity.slug = self.slug
	
	self.asset_entities.each do |ae|	
		_default_entity.asset_entities.build(:asset_id => ae.asset_id, :key => ae.key, :meta => ae.meta)
	
	end
	
	self.taxonomy_term_entities.find_each do |tte|
	
		_default_entity.taxonomy_term_entities.build(:taxonomy_term_id => tte.taxonomy_term_id)
	end
	
	_ob_fields = _default_entity.site_entitable.object_fields.map {|f| f.name }
	
	self.field_entities.joins(:field).where(:fields => {:name => _ob_fields}).find_each do |ef|
		_default_entity.field_entities.build(:field_id => ef.field_id, :value => ef.value)
				
	end
	
	self.related_site_entities.find_each do |re|
		_related_default_entity = re.related_entity.site_entitable.default_entity
		
		unless _related_default_entity.nil?
		
			_default_entity.related_site_entities.build(:related_site_entity_id => _related_default_entity.id, :priority => re.priority)
		
		end
		
	end
	_default_entity.save!  	
  
  
  end
  
  private
  
  def filter_slug
  	_slug = slug.strip() unless slug.nil?
  	
  	unless _slug.nil?
  		_slug = nil if _slug.blank?
  		
  		_slug = _slug.to_slug unless _slug.nil?
  	end
  	
  	self.slug = _slug
  end
end
