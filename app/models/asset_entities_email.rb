class AssetEntitiesEmail < Email

	
  attr_accessor :asset_entity_ids, :asset_entities
  
  validates :asset_entity_ids, :presence => true
  
  
  def asset_entity_ids=(value)
  	[].tap do |o|
  		value.each do |v|
  			ae = AssetEntity.site(Site.current.id).find(v)
  			
  			unless ae.nil?
  				o << v
  				asset_entities << ae
  			end
  			
  		end
  	end
  end
  
  def asset_entities
  	@asset_entities ||= []
  #	AssetEntity.site(Site.current.id).where(:asset_entities => {:id => @asset_entity_ids})
  end
  
end