class CityRegionCondition < RegionCondition
  belongs_to :city, :foreign_key => :value
  attr_accessible :city
  
  def label
  	city.name
  end
  
  def self.condition_join
   	"region_conditions.type = 'CityRegionCondition' AND cities.id = region_conditions.value"
  end
end