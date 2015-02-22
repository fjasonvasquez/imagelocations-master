class Location < ActiveRecord::Base
    
  include EntityMethods::Model
  allow_site_entities true
  
  def self.location_name_sql(series_table = "series", locations_table = "locations")
  	adapter = ActiveRecord::Base.connection.instance_values["config"][:adapter].to_sym
  	
  	sql_string = (adapter == :mysql2) ? "CONCAT(LOWER(#{series_table}.name),'%',#{locations_table}.series_number)" : "#{series_table}.name || ' ' || #{locations_table}.series_number"
  end
  
  def self.q(string)
  
  	
  	parts = [].tap { |o| string.split(",").map{|p|  p.strip.downcase }.each {|p| o << "%" + p.gsub(/\b0*/, "").gsub(/[ -]/,"_") + "%" if p.length > 1}}
  	
  	unless parts.empty?
  		adapter = ActiveRecord::Base.connection.instance_values["config"][:adapter].to_sym
  		
	  	search_fields = ["full_name","series.name","categories.name","taxonomy_terms.name","field_entities.value","cities.name", "states.name"]
	  	search_field_order_exceptions = {
		  	:full_name => self.location_name_sql("series")
		}
	  	
	  	where_clauses = [].tap do |o|
	  		parts.each do |part_order|
	  			o << [].tap do |o2|
	  				search_fields.each_with_index do |sf, index|
	  					sf = search_field_order_exceptions[sf.to_sym] if search_field_order_exceptions.has_key?(sf.to_sym)
	  					
	  					
	  					
	  					o2 << sanitize_sql_array(["lower(#{sf}) LIKE ?", part_order])
	  				end
	  			end.join(" OR ")
	  		end
	  	end
	  	
	  	
	  	order_clauses = [].tap do |o|
	  		search_fields.each_with_index do |sf, index|
	  			o << [].tap do |o2|
		  			parts.each do |part_order|
		  				sf = search_field_order_exceptions[sf.to_sym] if search_field_order_exceptions.has_key?(sf.to_sym)
		  			
		  				o2 << sanitize_sql_array(["lower(#{sf}) LIKE ?", part_order])
		  			end
		  		end.join(" OR ")
	  		end
	  	end
	  	
	  	
	  	
	  	order_clauses.map!{|order| "(#{order}) DESC"}
	  	
	  	order_clauses << "locations.series_number ASC"
	  	
	  	
	  	
	  	joins(:site_entities, :series, :city, :state)
	  	.includes(:categories, :site_entities => [:field_entities, :taxonomy_terms])
	   	.where(where_clauses.join(" AND "))
	  	.reorder("#{order_clauses.join(", ")}")
	  	.group("locations.id")
	  	.order_by_fullname('ASC')
	  else
	  	scoped
	  end
  end
  
  
  belongs_to :series, :counter_cache => true, :autosave => true, :validate => true, :inverse_of => :locations, :touch => true
  
  #belongs_to :series_name_only, :select => "series.id, series.name", :class_name => "Series", :foreign_key => "series_id"
  
  belongs_to :permit, :counter_cache => true, :touch => true
  
  #belongs_to :permit_name_only, :select => "permit.id,permit.name", :class_name => "Permit", :foreign_key => "permit_id"
  
  belongs_to :city, :autosave => true, :counter_cache => true, :touch => true
  
  #belongs_to :city_name_only, :select => "city.id, city.name", :class_name => "City", :foreign_key => "city_id"
  
  has_one :state, :through => :city
  
  has_and_belongs_to_many :categories
  
  #tears
  has_many :tears
  
  attr_accessor :name
  
  attr_accessible :name, :city_name, :city_id, :location_id, :taxonomy_term_ids, :site_ids, :series_id, :series_number, :series_name, :permit_id, :permit
  attr_accessible :field_entities_attributes
  attr_accessible :series_attributes
  attr_accessible :city_attributes
  
  attr_accessible :categories, :category_ids
  
  attr_accessible :address, :postcode, :latitude, :longitude
  
  geocoded_by :full_address
  after_validation :geocode, :if => proc { |l| l.address_field_changed? && l.has_address?}
  
  
  scope :excluding_ids, lambda { |ids| where(['locations.id NOT IN (?)', ids]) if ids.any? }
  
  scope :by_letter, lambda { |letter = nil| joins(:series).where('series.name LIKE ?', letter+"%") unless letter.nil? }
  scope :by_category, lambda { |cat| joins(:categories).where( :categories => { :id => cat}) }
  
  scope :exclusive, -> { joins(:categories).where( :categories => { :type => "ExclusiveCategory"}) }
  
  scope :order_by_fullname_only, lambda { |direction| joins(:series).order("series.name #{direction}, locations.series_number #{direction}") }
  
  
  if ActiveRecord::Base.connection.instance_values["config"][:adapter].to_sym == :mysql2
  
  	scope :order_by_fullname, lambda { |direction| joins(:series).order("CONCAT(site_entities.entity_title, series.name) #{direction}, locations.series_number #{direction}") }
  else
  
  	scope :order_by_fullname, lambda { |direction| joins(:series).order("site_entities.entity_title || ' ' || series.name #{direction}, locations.series_number #{direction}") }
  end
  
  
  
  scope :by_city, lambda { |city| where(:locations => {:city_id => city}) unless city.empty? }
  scope :by_permit, lambda { |permit| where(:locations => {:permit_id => permit}) unless permit.empty?}
  
  scope :by_region, lambda {|region| region(region) }
  
  scope :region, lambda {|region| regions().where(:regions => {:id => region}) }
  
  
  
  
  def self.regions
  	
  	joins(:city).joins(:state).joins(RegionCondition.condition_join_statement)
  	#scoped
  end
  
  
  #default_scope includes(:series)
  #accepts_nested_attributes_for :location_series, allow_destroy: true
  
  
  accepts_nested_attributes_for :series, allow_destroy: false
  accepts_nested_attributes_for :city, allow_destroy: false
  
  
  #delegate :name, :to => :series, :prefix => true, :allow_nil => true
  
  delegate :id, :to => :series, :prefix => true, :allow_nil => true
  
  delegate :name, :to => :city, :prefix => true, :allow_nil => true
  
  #has_many :taxonomy_term_entities, :as => :taxable, :dependent => :delete_all
  
  #validates_presence_of :series_name
  #validates_associated :series
  
  has_many :fields , :through => :field_entities
  
  #default_scope includes(:series)
  #before_save :save_series_name
  
  #has_many :asset_entities, :as => :asset_entitable, :dependent => :delete_all
  #validate :series_number_valid
  validates :series_number, :uniqueness => { :scope => :series_id }
  
  validates_presence_of :city
  validates_presence_of :series
  #validates_uniqueness_of :

  # def series_attributes=(value)
#    ap value
#    
#   	self.series = Series.find(value["id"]) unless value["id"].nil?	
#   	self.series ||= Series.find_by_name(value["name"]) unless value["name"].nil?
#   	self.series ||= Series.new(value)
#   	ap self.series
#   end
  
  def series_number
  	unless self[:series_number].nil? then self[:series_number] else 0 end
  end
  
  def series_name
    series && series.name
  end

  def series_name=(value)
    self.series = Series.find(:first, :conditions => [ "lower(name) = ?", value.downcase ])
    self.series ||= Series.new(:name => value, :locations_count => 1)
  end
  
  def address_field_changed?
  	
  	self.address_changed? || self.postcode_changed? || self.city_id_changed?
  end
  
  def has_address?
  	
  	self.address? || self.postcode? || self.city_id?
  end
  
  def name

  	fullname = "#{series_name}"
  	fullname << " #{series_number}" unless series_number.nil? || series_number.zero?
  	fullname
  end
  
  def full_address
  	[address, city.name, city.state.name, city.state.country_name].compact.join(', ')
  end
  
  def as_json options=nil
    options ||= {}
    options[:methods] = ((options[:methods] || []) + [:name])
    super options
  end
  
  def autosave_associated_records_for_city
  	
    if existing_city = City.includes(:state).where("lower(cities.name) = ? AND lower(states.name) = ? AND states.country_alpha2 = ?",city.name.downcase, city.state.name.downcase, city.state.country_alpha2).first
      self.city = existing_city
    else
      self.city.save!
      self.city_id = self.city.id
    end unless (city.nil? || city.state.nil?)
    
    self.city.build_current_entity(:site => Site.current).save! if !self.city.nil? && self.city.current_entity.nil?
    
    #ap self.city.build_current_entity(:site => Site.current)
  end
    
  def invalid_series_numbers

  	numbers = [].tap do |o|
  		series.locations.reject{|l| l == self }.each{|l| o << l.series_number} unless series.nil?
  	end
  end
    
  def name=(name)
  	self.series = Series.find_or_initialize_by_name(name)
  	unless self.series.id.nil?
  		invalid = self.invalid_series_numbers
  		while invalid.include?(self.series_number)
  			self.series_number += 1
  			
  		end
  	end
  end
    
  def self.search_by_name(string)
  	condition = ["%" + string.downcase.gsub(" ","%") + "%"]
  	includes(:series).joins(:current_entity).where("LOWER(series.name) LIKE ? OR #{self.location_name_sql} LIKE ? OR LOWER(site_entities.entity_title) LIKE ?",condition,condition,condition).order("series.name ASC, locations.series_number ASC")
  	
  end
  
  
  def self.search(string)
  	search_by_name(string)
  end
  
  def self.available_by_letter
  	trim_name = "substr(upper(trim(series.name)), 1,1)"
  	
  	select("#{trim_name} as letter")
  	.joins(:series)
  	.joins(:site_entities)
  	.group(trim_name)
  end
  

  
  private
  	def series_number_valid
  		errors.add(:series_number, "Series number already exists") if self.invalid_series_numbers.include?(self.series_number)
  	end
  
  
end
