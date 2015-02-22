class City < ActiveRecord::Base
  include EntityMethods::Model
  allow_site_entities true
  
  attr_accessible :state, :state_id, :latitude, :longitude, :name, :full_name, :logo, :timezone
  
  attr_accessible :state_attributes
  
  
  mount_uploader :logo, LogoUploader
  
  belongs_to :state, :inverse_of => :cities, :autosave => true
  has_many :locations
  
  accepts_nested_attributes_for :state, allow_destroy: false
  
  validates_associated :state
  validates_presence_of :state
  
  validates_presence_of :name
  #before_save :save_state, if: ->(o){ o.state_id.nil? }
  
  geocoded_by :city_state_country
  after_validation :geocode, :if => :name_changed?
  
  after_validation :set_timezone, :if => :name_changed?
  
  has_many :region_conditions, :finder_sql => ""
  
  default_scope order("cities.name ASC")
  
  before_destroy :can_be_destroyed?
  
  
  def self.regions
  	joins(:state).joins(RegionCondition.condition_join_statement)
  	#scoped
  end
  
  
  def self.search(string)
  	condition = ["%" + string.downcase.gsub(" ","%") + "%"]
  	
  	where("LOWER(cities.name) LIKE ?",condition)
  end
  
  def self.site(site)
  	joins(:locations)
  	.joins("INNER JOIN site_entities s2 ON 
  			s2.site_entitable_type = 'Location' 
  			AND s2.site_entitable_id = locations.id
  			AND s2.status = '#{SiteEntity.published_status}'
  			AND s2.site_id = #{site}")
  end
  
  
  
  def full_name
  	
  	[].tap do |o|
  		o << name
  		o << state.state_code unless state.state_code.nil?
  		o << state.name if state.state_code.nil?
  	end.join(", ")
  end
  
  
  
  def timezone
  	Timezone::Zone.new({:zone => self[:timezone]}) unless self[:timezone].nil?
  end

  
  def current_time
  	timezone.time Time.now unless timezone.nil?
  end
  
  def set_timezone
  	self.timezone = Timezone::Zone.new(:latlon => [latitude,longitude]).zone unless latitude.nil? || longitude.nil?
  	
  end
  
  def autosave_associated_records_for_state
  	
    if existing_state = State.find(:first, :conditions => ["lower(name) = ? AND country_alpha2 = ?",state.name.downcase, state.country.alpha2])
      self.state = existing_state
    else
      self.state.save!
      self.state_id = self.state.id
    end
  end
  
  def save_state
  	self.state_id = self.state.id
  end
  
  def city_state_country
  	[name, state.name, state.country_name].compact.join(', ')
  end
  
  def coordinates_changed?
  	latitude_changed? || longitude_changed?
  end
  
  
  
  def can_be_destroyed?
  	errors.add :base, "Cannot delete a city with locations" unless locations.count == 0
  	
  	locations.count == 0
  end
end
