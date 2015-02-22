class ImagelocationsProjectsController < ProjectsController
	force_non_ssl
		
	#before_filter :exclusive_locations, :only => [:show]
	
	
	#private
	#	def exclusive_locations
		
		
	#		@exclusive_location_banners = apply_scopes(LocationBannerEntity).includes(:location).published().by_section(:project_exclusives)
	#	end
end
