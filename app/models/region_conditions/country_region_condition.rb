class CountryRegionCondition < RegionCondition
  
  def label
  	Country.find_country_by_alpha2(self.value).name
  end
  
  
  
  
  def self.condition_join
   	"region_conditions.type = 'CountryRegionCondition' AND states.country_alpha2 = region_conditions.value"
  end
  
end