class ImagelocationsLocationsController < LocationsController
	
	force_non_ssl
	
	before_filter :set_search_per_page

	def show
    	@location = apply_scopes(Location).published().find(params[:id])
		
		@gallery_images = @location.current_assets_by_key(:gallery)
		
		@collage_images = @location.current_assets_by_key(:collage)
		
		@tears = apply_scopes(@location.tears.published().has_cover()).by_order()
		
		respond_to do |format|
			format.html # show.html.erb
			format.json { render json: @location }
		end
	end
	
	private
	
		def set_search_per_page
			
			params[:per_page] = 20
		end
	
end