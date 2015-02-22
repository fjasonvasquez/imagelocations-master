class WeddingestatesLocationsController < LocationsController


	before_filter :set_search_per_page
	before_filter :can_view_private?, :only => [:show]
	
	
	def show
    	
		
		@gallery_images = @location.current_assets_by_key(:gallery)
		
		#@tears = apply_scopes(@location.tears.published())
		
		respond_to do |format|
			format.html
		end
	end
	
	private
	
		def set_search_per_page
			
			params[:per_page] = 20
		end
		
		def can_view_private?
			
			@location = apply_scopes(Location).published().find(params[:id])
			
			if @location.field_entities.by_field("private").where(:field_entities => { :value => "1"}).count > 0 && !user_is_subscribed? && !user_is_admin?
				
				if user_signed_in?
			        redirect_to checkout_path(:protocol => 'https://') and return
                else 
                    store_location_for(:user, checkout_path)
			        redirect_to new_user_registration_path and return
                end 
			end
		end
		
end