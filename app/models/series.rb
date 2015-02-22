class Series < ActiveRecord::Base
  include EntityMethods::Model
  allow_site_entities true
  
  attr_accessor :location, :next_series_number, :series_numbers
  
  attr_accessible :name, :locations_count, :location_ids
  
  has_many :locations, :order => "series_number ASC", :inverse_of => :series
  
  has_many :cities, :through => :locations
  
  validates :name, :presence => true
  
  
  def self.search(string)
  	condition = ["%" + string.downcase + "%"]
  	where("LOWER(name) LIKE ?",condition)
  end
  
  def self.site(site)
  	joins(:locations => :current_entity).group("series.id")
  end
  
  def next_series_number
  	
  	unless locations.any? then 0 else locations.last.series_number + 1 end
  	
  end
  
  def series_numbers
  	[].tap do |o|
  		locations.find_each { |l| o << l.series_number } if locations.any?
  	end
  end
  
  def series_numbers_sites
  	[].tap do |o|
  		locations.find_each { |l| o << { :series_number => l.series_number, :sites => l.sites.map(&:id) }} if locations.any?
  	end
  end
  
  
  def as_json(options = nil)
    options ||= {}
    options[:methods] = ((options[:methods] || []) + [:location_ids, :locations, :series_numbers, :next_series_number])
    super options
  end
  
end
