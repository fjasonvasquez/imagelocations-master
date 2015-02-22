object @locations
attributes :id, :name, :series_number
node(:add_similar_location_field) { |location| render(:partial => 'similar_location_entity_fields', 
													  :locals => {
													  		:f => fields_for([@location,@site_entity]), 
													  		:similar_location_entity => @site_entity.similar_locations.build([{:similar_location => location}])}) }