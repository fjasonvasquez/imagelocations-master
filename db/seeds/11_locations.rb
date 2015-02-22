# Locations

default_locations = [
	{
		:name => 'Beach House',
		:address => 'Zumirez dr.',
		:permit => $PERMITS.first,
		:city_attributes => {
			:name => 'Malibu',
			:state_attributes => {
				:name => 'California',
				:country_name => 'United States'
			}
		},
		:site_entities_attributes => [
			{
				:site => $SITES.first
			}
		]
	},
	{
		:name => 'Avila Mansion',
		:city_attributes => {
			:name => 'Los Angeles',
			:state_attributes => {
				:name => 'California',
				:country_name => 'United States'
			}
		}
	},
	{
		:name => 'Modern',
		:city_attributes => {
			:name => 'Los Angeles',
			:state_attributes => {
				:name => 'California',
				:country_name => 'United States'
			}
		}
	},
	{
		:name => 'Modern',
		:city_attributes => {
			:name => 'Los Angeles',
			:state_attributes => {
				:name => 'California',
				:country_name => 'United States'
			}
		}
	},{
		:name => 'Mansion',
		:city_attributes => {
			:name => 'Los Angeles',
			:state_attributes => {
				:name => 'California',
				:country_name => 'United States'
			}
		}
		
	}

]


$LOCATIONS = Location.create(default_locations)


$LOCATIONS.first.site_entities.first.asset_entities << AssetEntity.new({:key => "cover", :asset => $IMAGES.first})