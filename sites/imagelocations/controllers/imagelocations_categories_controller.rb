class ImagelocationsCategoriesController < CategoriesController
	
	force_non_ssl
	
	def index
		
		_section = unless params[:section].nil? then params[:section] else nil end
		
		@exclusive_location_banners = LocationBannerEntity.includes(:location).published().by_section(:exclusive_locations).page(params[:page]).per(15).site(current_site.id)
		@exclusive_location_banners = @exclusive_location_banners.region(current_region.id) unless params[:region].nil?
		
		
		@exclusive_locations = [].tap do |o|
			@exclusive_location_banners.each do |be|
				if be.respond_to?(:location)
					o << be.location
				end
			end
		end
		
		@exclusive_location_banner_thumbs = begin
			_exclusive_thumb = LocationBannerEntity.published().by_section(:exclusive_locations_thumbs).site(current_site.id)
			_exclusive_thumb = _exclusive_thumb.region(current_region.id) unless params[:region].nil?
			
			#if !_exclusive_thumb.any? && @exclusive_location_banners.any?
			#	_exclusive_thumb.offset((@exclusive_location_banners.current_page - 1) % _exclusive_thumb.count).limit(1).first.location
			#else
			#	nil
			#end
			_exclusive_thumb
		end
		
		
		if _section == "exclusive_locations"
			render "categories/exclusive_locations" and return
		end
		
		
		@featured_categories = apply_scopes(Category).published().special_and_featured()
		
		
		@categories = apply_scopes(Category).published().order("categories.name ASC").page(params[:page]).per(per_page)
		
		@categories_list = @categories.except(:limit, :offset).select("categories.id, categories.name").order("categories.name ASC")
		
		respond_with @categories
	end
end
