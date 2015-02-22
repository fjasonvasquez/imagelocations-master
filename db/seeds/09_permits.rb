#Permits

permit_data = [
	{:name=>"Beverly Hills"}, 
	{:name=>"Film LA",
	 :site_entities_attributes => [
	 	{
	 		:site => $DEFAULT_SITE,
		 	:field_entities_attributes => [
		 		{
			 		:field => Field.find_by_name("description"),
			 		:value => "<span><b>FILM LA</b><br>72 Hour Advance Notice<br>Min. 4 Days Notice to Post on Streets for Parking<br>For Stills - Cast/Crew over 14 will incur Motion Rates<br>For Stills - Adding of Behind the Scenes Video will incur Motion Rates<br>7:00am - 10:00pm -&nbsp; Monday - Friday without Signatures<br>9:00am - 10:00pm - Saturday - Sunday without Signatures<br>Some locations will require contacting Homeowner's Associations<br>Questions? Call 310-871-8004</span>"
		 		}
		 	]
	 	}
	 ]
	}, 
	{:name=>"Malibu "}, 
	{:name=>"Glendale"}, 
	{:name=>"Culver City"}, 
	{:name=>"CA State"}, 
	{:name=>"Palm Springs"}, 
	{:name=>"Pasadena"}, 
	{:name=>"Santa Barbara"}, 
	{:name=>"New York"}
]





$PERMITS = Permit.create(permit_data)