default_tears = [
	{
		:name => "Vanity Fair",
		:cover => File.open("#{Rails.root}/db/seeds/assets/images/tears/vanity.jpg"),
		:site_entities_attributes => [
			{
				:site => $SITES.first
			}
		]
	},
	{
		:name => "Glamour",
		:cover => File.open("#{Rails.root}/db/seeds/assets/images/tears/glamour.jpg"),
		:site_entities_attributes => [
			{
				:site => $SITES.first
			}
		]
	}
]

$TEARS = Tear.create(default_tears)