class Region < ActiveRecord::Base
   include EntityMethods::Model
   allow_site_entities true
   
   serialize :weather_forecast
   
   attr_accessible :name, :weather_city_id, :weather_forecast, :region_conditions_attributes
   attr_accessible :country_region_conditions_attributes
   attr_accessible :state_region_conditions_attributes
   attr_accessible :city_region_conditions_attributes
   
   has_many :region_conditions, :dependent => :delete_all
   has_many :country_region_conditions
   has_many :state_region_conditions
   has_many :city_region_conditions
   
   has_many :states, :through => :state_region_conditions
   has_many :cities, :through => :city_region_conditions
   
   belongs_to :weather_city, :foreign_key => "weather_city_id", :class_name => "City"
   
   accepts_nested_attributes_for :region_conditions, allow_destroy: true
   accepts_nested_attributes_for :country_region_conditions, allow_destroy: true
   accepts_nested_attributes_for :state_region_conditions, allow_destroy: true
   accepts_nested_attributes_for :city_region_conditions, allow_destroy: true
   
   
   after_validation :set_weather_forecast, :if => proc { |r| r.weather_city_id_changed?}
   
   delegate :timezone, :to => :weather_city, :allow_nil => true
   delegate :current_time, :to => :weather_city, :allow_nil => true
   
   #has_many :states, :through => :region_entities, :source => :region_entitable, :source_type => 'State'
   #has_many :cities, :through => :region_entities, :source => :region_entitable, :source_type => 'City'
   
  
   
   def self.region_cities
  	
  	joins(:city).joins(:state).joins(RegionCondition.condition_join_statement)
  	#scoped
   end
   
   def region_cities
  	
  	City.joins(:state).joins(RegionCondition.condition_join_statement).where(:regions => { :id => self.id}).uniq
  	#scoped
   end
   
   def weather_forecast
   	   if (self[:weather_forecast].nil? || (self[:weather_forecast][:timestamp] + 3600 < Time.now.to_i)) && !readonly?
   	   	set_weather_forecast
   	   	self.save!
   	   end
   	   self[:weather_forecast][:data] unless self[:weather_forecast][:data].nil?
	   #self[:weather_forecast]
   end
   
   def weather_timestamp
   	   self[:weather_forecast][:timestamp] unless self[:weather_forecast].nil? || self[:weather_forecast][:timestamp].nil?
   
   end
   
   
   def current_weather_forecast
   	self.weather_forecast[:currently] unless self.weather_forecast.nil?
   end
   
   def daily_weather_forecast
   	self.weather_forecast[:daily] unless self.weather_forecast.nil?
   end
   
   def current_temperature
   	self.current_weather_forecast[:temperature] unless weather_city.nil? || self.current_weather_forecast.nil?
   	
   end
   
   def current_summary
   	self.current_weather_forecast[:summary] unless self.current_weather_forecast.nil?
   end
   
   def current_weather_icon
   	self.current_weather_forecast[:icon] unless self.current_weather_forecast.nil?
   end
   
   
   def current_week
   
   
   end
   
   
   def weather_forecast=(val)
   	data = {
	   	:timestamp => Time.now.to_i,
	   	:data => val
   	}
   	self[:weather_forecast] = data
   
   end
   
   
   def set_weather_forecast
   		self.weather_forecast = nil
   		self.build_weather_city() if self.weather_city.nil?
   		
   		self.weather_forecast = Forecast::IO.forecast(self.weather_city.latitude, self.weather_city.longitude) unless (self.weather_city.latitude.nil? || self.weather_city.longitude.nil?)
   		
   end
   
   
   def locations(reload=false)
   		@locations = nil if reload
   		@locations ||= Location.includes(:city, :state).where("cities.id IN (?) OR states.id IN (?) OR states.country_alpha2 IN (?)",
   															  city_ids, state_ids,[].tap {|o| country_region_conditions.each {|c| o << c.value}})
   end
   
   
   def initialized_country_region_conditions 			
    countries = [].tap { |o| State.group_by_countries.each {|s| o << s.country_alpha2 } }
    
    [].tap do |o|
        countries.each do |country|
        	if  crc = country_region_conditions.find { |crc| crc.value == country }
        		o << crc.tap { |crc| crc.enable ||= true }
        	else
        		o << country_region_conditions.new({:value => country})
        	end
        end
    end
  end

  def initialized_state_region_conditions 			
    	
	    [].tap do |o|
	        State.all.each do |state|
	        	if  src = state_region_conditions.find { |src| src.value.to_i == state.id }
	        		o << src.tap { |src| src.enable ||= true }
	        	else
	        		o << state_region_conditions.new({:value => state.id})
	        	end
	        end
	    end
  end
  
  def initialized_city_region_conditions 			
    	
	    [].tap do |o|
	        City.all.each do |city|
	        	if  src = city_region_conditions.find { |src| src.value.to_i == city.id }
	        		o << src.tap { |src| src.enable ||= true }
	        	else
	        		o << city_region_conditions.new({:value => city.id})
	        	end
	        end
	    end
  end
   
end
