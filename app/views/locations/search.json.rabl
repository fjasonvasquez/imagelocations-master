object false
node(:locations) { partial('locations/_search.json.rabl', :object => @locations) }

node(:_results) do
	{
		:total_count => @locations.total_count
	
	}
end