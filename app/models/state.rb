class State < ActiveRecord::Base
  include EntityMethods::Model
  allow_site_entities true
  
  attr_accessor :country_name
  attr_accessor :country
  attr_accessible :country, :country_alpha2, :latitude, :longitude, :name, :country_name
  
  #validates :country_name, :presence => true
  validate :valid_country
  
  validates_presence_of :name
  validates_presence_of :country_alpha2
  
  before_save :set_codes
  
  has_many :cities, :inverse_of => :state
  has_many :locations, :through => :cities
    
  scope :by_country, lambda { |country_alpha2| where( :country_alpha2 => country_alpha2) }
  
  before_destroy :can_be_destroyed?
  
  def set_codes
  	country = Country.find_country_by_name(@country_name)	
  	self.country_alpha2 ||= country.alpha2

  	self.state_code = begin
  		result = Geocoder.search("#{self.name}, #{self.country_alpha2}")
  		"".tap do |o|
  				result.first.data["address_components"].each {|r| o << r["short_name"] if r["types"].include?("administrative_area_level_1")}
  		end
  	rescue
  		nil
  	end if self.name_changed? || self.country_alpha2_changed?
  end
  
  def country_name
  	country.name unless country.nil?
  end
  
  def country
  	@country ||= Country.find_country_by_alpha2(self.country_alpha2)
  end
  
  def self.find_by_name_and_country(name, country_name)
  	c = Country.find_country_by_name(country_name)
  	where("states.name = ? AND states.country_alpha2 = '#{c.alpha2}", name)
  end
  
  def self.group_by_countries
  	
  	group("states.country_alpha2")
  
  end
  
  def name=(s)
  	self[:name] = s.respond_to?(:trim) ? s.trim : s
  end
  
  def country_name=(name)
  	@country = Country.find_country_by_name(name)
  	self.country_alpha2 = @country.alpha2 unless @country.nil?
  end
  
  def valid_country
  	errors.add(:country_name, "Could not find valid country") if country.nil?
  end
  
  def self.countries
  	group(:country_alpha2).order("country_alpha2 ASC")
  end
  
  private
  
  def can_be_destroyed?
  	errors.add :base, "Cannot delete a state with cities" unless cities.count == 0
  	
  	cities.count == 0
  end
  
end
