namespace :setup do
	
	task :build_defaults => :environment do
		
		SOURCE = :imagelocations
		
		site = Site.find_by_namespace(SOURCE)
		
		
		site.site_entities.where(:site_entitable_type => "Location").find_each do |site_entity|
		
			site_entity.build_and_save_default(true)
			
		end
	
	end
	
	task :weddingestates_set_private => :environment do
		
		site = Site.find_by_namespace(:weddingestates)
	
		site_locations = site.locations
		
		site_locations.find_each do |location|
		
		
			location.field_entities.includes(:field).where(:fields => {:name => "private", :site_id => site.id}).find_each do |fe|
							
				fe.value = "1"				
				fe.save!

			end
	

		
		end	
	end
	
	task :weddingestates => :environment do
		
		hostname = Rails.env.development? ? "weddingsdev.com" : "weddingestates.com"
		
		#Site.find_or_initialize_by_namespace(:weddingestates).destroy
		
		site = Site.find_or_initialize_by_namespace(:weddingestates)
		
		site.id = 2
		
		site.update_attributes({
			:hostname => hostname,
			:name => "Wedding Estates",
			:namespace => :weddingestates,
			:active => 1,
		})
		
		#ASSET SIZES
		
		ASSET_SIZES = [
				{
					:key => :cover,
					:process => :resize_to_fill,
					:height => 300,
					:width => 300
				},
				{
					:key => :extended,
					:height => 200,
					:width => 1056
				},
				{
					:key => :grid,
					:process => :resize_to_fit,
					:height => 215,
					:width => 1400	
				},
				{
					:key => :gallery,
					:process => :resize_to_fit,
					:height => 566,
					:width => 2400,
					:watermark => true
				},
				{
					:key => :background,
					:process => :resize_to_fit,
					:height => 1400,
					:width => 1400	
				}
			]
		
		ASSET_SIZES.each do |as|
			asset_size = site.asset_sizes.find_or_initialize_by_key(as[:key])
			
			asset_size.update_attributes(as)
			
			
		end
		
		#SECTIONS
		
		
		SECTIONS = [
				{
					:name => "Regions",
					:key => :regions,
					:section_objects_attributes => [
						{
							:object => CityBannerEntity
						},
						{
							:object => RegionBannerEntity
						},
						{
							:object => CustomBannerEntity
						}
					]
				},
				{
					:name => "Front Slideshow",
					:key => :home_slideshow,
					:limit => 1,
					:section_objects_attributes => [
						{
							:object => LocationBannerEntity
						}
					]
				}
		]
		
		
		SECTIONS.each do |s|
			section = site.sections.find_or_initialize_by_key(s[:key])
			section.update_attributes(s)
		end
		
		#SETTINGS
		
		SETTINGS = [
				{
					:key => 'site_title',
					:value => 'Wedding Estates'	
				},{
					:key => 'meta_keywords',
					:value => 'filming locations in los angeles, los angeles film locations, photo shoot locations in los angeles, photography locations in los angeles'
				},{
					:key => 'meta_description',
					:value => 'Filming locations in Los Angeles - the premier choice for motion pictures, television, and photography locations. The original Location Agents.',
					:options => {
						:as => :text
					}
				}
			]
		SETTINGS.each do |s|
			setting = site.settings.find_or_initialize_by_key(s[:key])
			setting.update_attributes(s)
		
		end
		
		PLANS = [
			{
				:name => "Membership",
				:duration => 365,
				:price => 79,
				:saleable => true
			}
		
		]
		
		PLANS.each do |pl|
			plan = site.plans.find_or_initialize_by_name(pl[:name])
			plan.update_attributes(pl)
		end
		
		FIELDS = [
			{
				:name => 'private',
				:args => {
					:as => :boolean,
					:input_html => {
						:class => ''
					}
				},
				:field_objects_attributes => [
					{
						:object => Location.name
					}
				]
			}
		
		]
		
		FIELDS.each do |f|
			field = site.fields.find_or_initialize_by_name(f[:name])
			
			field.update_attributes(f)
		end
	end
	
	task :weddingestates_custom_fields => :environment do
	
		
		site = Site.find_by_namespace(:weddingestates)
		
		FIELDS = [
			{
				:name => 'additional_info',
				:args => {
					:as => :wysiwyg,
					:input_html => {
						:class => 'input-block-level'
					}
				},
				:field_objects_attributes => [
					{
						:object => Location.name
					}
				]
			},
			{
				:name => 'contact_info',
				:args => {
					:as => :wysiwyg,
					:input_html => {
						:class => 'input-block-level'
					}
				},
				:field_objects_attributes => [
					{
						:object => Location.name
					}
				]
			}
		
		]
		
		FIELDS.each do |f|
			field = site.fields.find_or_initialize_by_name(f[:name])
			
			field.update_attributes(f)
		end
		
		SECTIONS = [
				{
					:name => "Public Ads",
					:key => :ads,
					:section_objects_attributes => [
						{
							:object => AdBannerEntity
						}
					]
				}
		]
		
		
		SECTIONS.each do |s|
			section = site.sections.find_or_initialize_by_key(s[:key])
			section.update_attributes(s)
		end
		
	end
	
end