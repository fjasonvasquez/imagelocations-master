class Category < ActiveRecord::Base
    
  include EntityMethods::Model
  allow_site_entities true
  
  attr_accessible :name, :type, :series, :series_id
  
  validates_presence_of :name
  
  has_and_belongs_to_many :locations, :include => ["series"], :order => "series.name ASC, locations.series_number ASC"
  	  
  belongs_to :series
  
  has_many :cities, :through => :locations
  
  has_many :states, :through => :cities
  
  has_many :permits, :through => :locations
  
  
  scope :has_locations, lambda { joins(:locations).where("locations.id IS NOT NULL OR categories.type IS NOT NULL") }
  
  #scope :has_published_locations, lambda { joins(:locations => :site_entities ) }, :conditions => {:locations => { :site_entities => lamdaSiteEntity.published]} }
  
  scope :by_city, lambda { |city| joins(:locations).where(:locations => {:city_id => city}) }
  
  scope :by_cities, lambda { |cities| joins(:locations).where(:locations => {:city_id => cities}) }
  
  scope :region, lambda {|region| 
  								   unless region.nil?
  								   joins(RegionCondition.condition_join_statement)
  								  .joins(:locations => [:city,:state])
  								  .where(:regions => {:id => region})
  								  else
  								  scoped
  								  end
  						}
  
  scope :special_and_featured, -> {
  	includes(:current_entity => {:field_entities => :field})
  	.where(["(site_entities.site_id = ? AND fields.name = ? and field_entities.value = ?) OR categories.type IS NOT NULL",Site.current.id, "featured", "1"])
  	.reorder("categories.type IS NOT NULL DESC, categories.name ASC")
  }
  
  scope :special, lambda { where("categories.type IS NOT NULL")}
  
  default_scope order("categories.name ASC")
  
  def self.site(site)
  	
  	#joins(cl.join(l).on(l[:id]).join_sources.first)
  	#.joins("
  	#		LEFT JOIN site_entities s2 ON 
  	#			s2.site_entitable_type = 'Location' 
  	#			AND s2.site_entitable_id = locations.id
  	#			AND s2.status = '#{SiteEntity.published_status}'
  	#			AND s2.site_id = #{site}")
  	#joins(:locations => )

  	l = Arel::Table.new(:locations)
  	c_l = Arel::Table.new(:categories_locations)
  	
  	
  	#joins(l.join(c_l).join_sql)
  	joins(:locations => :current_entity)
  	.joins(self.categories_join)
  	.where(self.categories_where)
  	.group("categories.id")
  	#scoped
  end
  	
  def self.published()
	  joins(:locations => :current_published_entity)
	  .where(:site_entities => {:status => SiteEntity.published_status})
  end
  
  def self.search(string)
  	condition = ["%" + string.downcase + "%"]
  	where("LOWER(name) LIKE ?",condition)
  end
  
  def self.categories_join
	  	#category_joins = ["
	  	#	LEFT JOIN categories_locations ON
	  	#		categories_locations.category_id = categories.id
	  	#	LEFT JOIN locations ON
	  	#		locations.id = categories_locations.location_id
	  	#",
	  	[].tap do |o|
			self.subclasses.each do |s|
				o << "#{s.send(:category_join, scoped)}" if s.respond_to?(:category_join) && !s.send(:category_join,scoped).nil?
			end
		end.join(" ")
  end
  
  def self.categories_where
  	 
  		#["s2.id IS NOT NULL"].tap { |o|
	  	["site_entities.id IS NOT NULL"].tap { |o|	
	  		self.subclasses.each do |s|
	  			o << "(#{s.send(:category_where)})" if s.respond_to?(:category_where) && !s.send(:category_where).nil?
	  		end
	  	}.join(" OR ")
  end
  
  def current_asset_by_key_with_category(key = nil)
  		
		img = current_asset_by_key_without_category(key)
		
		img ||= locations.site(Site.current.id).published().first.current_asset_by_key(key) unless locations.site(Site.current.id).published().first.nil?
	end
	alias_method_chain :current_asset_by_key, :category
	
  def is_special?
  	
  end
	# 
# 	def current_assets_by_key(*keys)
# 		
# 		@current_assets ||= current_entity.asset_entities.includes(:asset_size).by_key(keys).any? ? current_entity.asset_entities.includes(:asset_size).by_key(keys) : default_entity.asset_entities.includes(:asset_size).by_key(keys)
# 		
# 	end
  
end
