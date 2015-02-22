namespace :cleaning do
	
	task :orphaned_taxonomy_entities => :environment do
	
		
		
		orphans = TaxonomyTermEntity.includes(:taxonomy).where("taxonomies.id IS NULL")
		
		_deleted = 0
		_found = orphans.count
		
		orphans.find_each do |tte|
			_deleted += 1 if tte.destroy
		end
		
		print "#{_found} orphaned taxonomy term entities were found\n"
		print "#{_deleted} were deleted"
	end
	
end