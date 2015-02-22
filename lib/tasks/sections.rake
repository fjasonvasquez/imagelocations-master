namespace :sections do
	desc "Create new banner sections"
	task :create  => [:environment] do
		
		
		print "Input site ID:\n"
		
		site =  Site.find(STDIN.gets.chomp.to_i)
		
		print "Input section name:\n"
		
		section_name = STDIN.gets.chomp
		
		print "Input section key:\n"
		
		section_key = STDIN.gets.chomp.downcase.underscore.to_sym
		
		print "Input section limit:\n"
		
		section_limit = STDIN.gets.chomp.to_i
		
		section = Section.new(:site => site, :key => section_key, :name => section_name, :limit => section_limit )
		
		banner_entities = BannerEntity.descendants.map(&:name).sort
		
		not_finished = true
		print "Add Entities\n"
		
		while not_finished
			
			print "Select Entity\n"
				
			banner_entities.each_with_index do |be, index|
			
				print "#{index}: #{be}\n"
				
			
			end
			
			print "#{banner_entities.count}: Finished\n"
			
			banner_id = STDIN.gets.chomp
			
			banner_entity = banner_entities.at(banner_id.to_i) unless banner_id.blank?
			
			unless banner_entity.nil?
				print "Allow Custom Banner Uploads? [Y/N] \n"
				custom_banner = STDIN.gets.chomp.downcase == "n" ? false : true
				
				section.section_objects.build(:object => banner_entity, :allow_banner => custom_banner)
				
			else
				
				not_finished = false
			end
		
		end
		
		section.save!
			
	end


end