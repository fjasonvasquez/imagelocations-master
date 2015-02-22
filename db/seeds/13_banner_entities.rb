default_locations_banner_entities = [
	{
		:section => $SITES.first.sections.find_by_key(:home),
		:banner_entity_site_entities_attributes => [
			{
				:site_entity => $LOCATIONS.first.site_entities.site($SITES.first).first
			}
		]
	},
	{
		:section => $SITES.first.sections.find_by_key(:featured_locations),
		:banner_entity_site_entities_attributes => [
			{
				:site_entity => $LOCATIONS.first.site_entities.site($SITES.first).first
			}
		]
	}

]



$LOCATIONS_BANNER_ENTITIES = LocationsBannerEntity.create(default_locations_banner_entities)


default_tears_banner_entities = [
	{
		:section => $SITES.first.sections.find_by_key(:featured_tear),
		:banner_entity_site_entities_attributes => [
			{
				:site_entity => $TEARS.first.site_entities.site($SITES.first).first
			}
		]
	}
]


$TEARS_HOME_ENTITIES = TearsBannerEntity.create(default_tears_banner_entities)