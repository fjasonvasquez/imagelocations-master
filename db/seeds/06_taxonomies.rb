# Taxonomies

#KEYWORDS
default_keyword_taxonomies = [
	{
		 :name => "Keyword",
		 :taxonomy_terms_attributes => [{
			 :name => 'Big'
		}]
	}
]

$KEYWORD_TAXONOMIES = KeywordTaxonomy.create(default_keyword_taxonomies)


#BOOLEANS

default_boolean_taxonomies = [
	{
		:name => "Beach Access",
		:public => true
	},
	{
		:name => "Rooftop Access",
		:public => true
	},
	{
		:name => "Exterior Only",
		:public => true
	}
]

$BOOLEAN_TAXONOMIES = BooleanTaxonomy.create(default_boolean_taxonomies)


#TAGS

default_tag_taxonomies = [
	{
		:name => "Feature",
		:public => true,
		:taxonomy_terms_attributes => [
			{
				:name => "Ocean View"
			},
			{
				:name => "Large Estate"
			}
		
		]
	},
	{
		:name => "Yard Description",
		:public => true,
		:taxonomy_terms_attributes => [
			{
		  	:name => "Arbor"
			},
			{
		  	:name => "Beach"
			},
			{
		  	:name => "Fountain"
			},
			{
		  	:name => "Garden"
			},
			{
		  	:name => "Green House"
			},
			{
		  	:name => "Hedges"
			},
			{
		  	:name => "Large Deck"
			},
			{
		  	:name => "Large Lawn"
			},
			{
		  	:name => "Palm Trees"
			},
			{
		  	:name => "Pond"
			},
			{
		  	:name => "Rose Garden"
			},
			{
		  	:name => "Tennis Court"
			},
			{
		  	:name => "Trees"
			},
			{
				:name => "Stones"
			}
		]

	},
	{
		:name => "Pool",
		:public => true,
		:taxonomy_terms_attributes => [
			{
				:name => "Traditional"
			},
			{
				:name => "Empty"
			},
			{
				:name => "Indoor"
			},
			{
				:name => "Infinity"
			},
			{
				:name => "Kidney"
			},
			{
				:name => "Lagoon"
			},
			{
				:name => "Lap"
			},
			{
				:name => "Large"
			},
			{
				:name => "Modern"
			},
			{
				:name => "Olympic"
			},
			{
				:name => "Oval"
			},
			{
				:name => "Reflection"
			},
			{
				:name => "Rooftop"
			}
		]
	},
	{
		:name => "Patio / Balcony",
		:public => true,
		:taxonomy_terms_attributes => [
			{:name=>"Furnished"}, 
			{:name=>"Large"}, 
			{:name=>"with Mountain View"}, 
			{:name=>"with Ocean View"}, 
			{:name=>"with View"}, 
			{:name=>"with city view"}
		]	
	},
	{
		:name => "View",
		:public => true,
		:taxonomy_terms_attributes => [
			{:name=>"Canal"}, 
			{:name=>"City"}, 
			{:name=>"Lake"}, 
			{:name=>"Mountain"}, 
			{:name=>"Ocean"}, 
			{:name=>"River"}, 
			{:name=>"View"}
		] 	
	},
	{
		:name => "Miscellaneous Rooms / Amenities",
		:public => true,
		:taxonomy_terms_attributes => [
			{:name=>"Bar"}, 
			{:name=>"Bathroom"}, 
			{:name=>"Chef's Kitchen"}, 
			{:name=>"Circular Staircase"}, 
			{:name=>"Gym"}, 
			{:name=>"Home Office"}, 
			{:name=>"Home Theater"}, 
			{:name=>"Library"}, 
			{:name=>"Music Room"}, 
			{:name=>"Pool Room"}, 
			{:name=>"Tennis Court"}, 
			{:name=>"Wine Cellar"}
		]
	},
	{
		:name => "Floor Description",
		:public => true,
		:taxonomy_terms_attributes => [
			{:name=>"Black"}, 
			{:name=>"Carpet"}, 
			{:name=>"Checkered"}, 
			{:name=>"Cobblestone"}, 
			{:name=>"Concrete"}, 
			{:name=>"Dark Wood"}, 
			{:name=>"Granite"}, 
			{:name=>"Light Wood"}, 
			{:name=>"Linoleum"}, 
			{:name=>"Marble"}, 
			{:name=>"Slate"}, 
			{:name=>"Tile"}, 
			{:name=>"White"}, 
			{:name=>"Wood"}
		]
		
	},
	{
		:name => "Wall Description",
		:public => true,
		:taxonomy_terms_attributes => [
			{:name=>"Black"}, 
			{:name=>"Brick"}, 
			{:name=>"Cold"}, 
			{:name=>"Colorful"}, 
			{:name=>"Neutral"}, 
			{:name=>"Stone"}, 
			{:name=>"Texture"}, 
			{:name=>"Wallpaper"}, 
			{:name=>"Warm"}, 
			{:name=>"White"}, 
			{:name=>"Wood Panel"}
		]
	}

]

$TAG_TAXONOMIES = TagTaxonomy.create(default_tag_taxonomies)


#SELECTS

#default_select_taxonomies = []

#$SELECT_TAXONOMIES = SelectTaxonomy.create(default_select_taxonomies)