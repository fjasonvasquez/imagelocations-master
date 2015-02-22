class Photographer < ActiveRecord::Base
  include EntityMethods::Model
  allow_site_entities true
  attr_accessible :name
  
  validates_uniqueness_of :name
  
  #has_many :photograper_assets, :source => 
  
  #has_many :asset_entities, :through => :assets
  
  
  def locations
  	p_arel = self.class.arel_table
  	
  	l_arel = Location.arel_table
	se_arel = SiteEntity.arel_table
	ae_arel = AssetEntity.arel_table
	
	a_arel = Asset.arel_table

	
	location_join = l_arel.join(se_arel, Arel::Nodes::InnerJoin)
	  	.on(se_arel[:site_entitable_id].eq(l_arel[:id]).and(se_arel[:site_entitable_type].eq("Location")))
	  .join(ae_arel,Arel::Nodes::InnerJoin)
	  	.on(
	  		ae_arel[:site_entity_id].eq(se_arel[:id])
	  	)
	  .join(a_arel,Arel::Nodes::InnerJoin)
	  	.on(
	  		a_arel[:id].eq(ae_arel[:asset_id]).and(a_arel[:photographer_id].eq(id))
	  	
	  	)
	  
	ap location_join
	
	Location.joins(location_join.join_sources).uniq
  end
  
  
end
