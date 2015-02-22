if ActiveRecord::Base.connection.instance_values["config"][:adapter] == "mysql2"
	ActiveRecord::Base.connection.execute('SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";')
end

$DEFAULT_SITE = Site.new({:name => "Default",:active => true,:asset_sizes_attributes => [
			{
				:key => :thumb,
				:height => 200,
				:width => 200
			},
			{
				:key => :cover,
				:height => 300,
				:width => 300
			},
			{
				:key => :extended,
				:height => 215,
				:width => 950
			},
			{
				:key => :grid,
				:process => :resize_to_fit,
				:height => 215,
				:width => 1400	
			},
			{
				:key => :gallery,
				:height => 500,
				:width => 750
			}
		]})

$DEFAULT_SITE.id = 0
$DEFAULT_SITE.save!


default_sites = [
	{
		:hostname => Rails.env.development? ? "192.168.1.5" : "geosith.com",
		:name => "Image Locations",
		:namespace => :imagelocations,
		:active => 1,
		:asset_sizes_attributes => [
			{
				:key => :cover,
				:height => 300,
				:width => 300
			},
			{
				:key => :gallery_thumb,
				:process => :resize_to_fit,
				:height => 200,
				:width => 950
			},
			{
				:key => :extended,
				:process => :resize_to_fit,
				:height => 290,
				:width => 950
			},
			{
				:key => :grid,
				:process => :resize_to_fit,
				:height => 290,
				:width => 1400	
			},
			{
				:key => :gallery,
				:process => :resize_to_fit,
				:height => 566,
				:width => 1400
			}
		],
		:sections_attributes => [
			{
				:name => "Featured Locations",
				:key => :featured_locations,
				:limit => 1,
				:section_objects_attributes => [
					{
						:object => LocationsBannerEntity
					}
				]
			},
			{
				:name => "Featured Tear",
				:key => :featured_tear,
				:limit => 1,
				:section_objects_attributes => [
					{
						:object => TearsBannerEntity
					}
				]
			},
			{
				:name => "Front Page",
				:key => :home,
				:section_objects_attributes => [
					{
						:object => CustomBannerEntity
					},
					{
						:object => LocationBannerEntity
					},
					{
						:object => LocationsBannerEntity
					}
				]
			},
			{
				:name => "Videos",
				:key => :videos,
				:section_objects_attributes => [
					{
						:object => CustomBannerEntity
					},
					{
						:object => VideoBannerEntity
					}
				]
			}

		],
		:settings_attributes => [
			{
				:key => 'site_title',
				:value => 'Welcome to Image Locations'	
			},{
				:key => 'meta_keywords',
				:value => 'filming locations in los angeles, los angeles film locations, photo shoot locations in los angeles, photography locations in los angeles'
			},{
				:key => 'meta_description',
				:value => 'Filming locations in Los Angeles - the premier choice for motion pictures, television, and photography locations. The original Location Agents.',
				:options => {
					:as => :text
				}
			},{
				:key => 'per_page',
				:controller => 'Home',
				:value => 20
			}
		]
    },
    {
		:hostname => "weddingestates.com",
		:name => "Wedding Estates",
		:namespace => :weddings,
		:active => 1,
		:asset_sizes_attributes => [
			{
				:key => :cover,
				:height => 300,
				:width => 300
			},
			{
				:key => :extended,
				:height => 215,
				:width => 950
			},
			{
				:key => :grid,
				:process => :resize_to_fit,
				:height => 215,
				:width => 1400	
			},
			{
				:key => :gallery,
				:height => 500,
				:width => 750
			}
		]
    }
]


$SITES = Site.create(default_sites)