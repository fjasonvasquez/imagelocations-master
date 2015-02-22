class StateRegionCondition < RegionCondition
  belongs_to :state, :foreign_key => :value
  attr_accessible :state
  
  def label
  	state.name
  end
  
  def self.condition_join
   	"region_conditions.type = 'StateRegionCondition' AND cities.state_id = region_conditions.value"
  end
  
end