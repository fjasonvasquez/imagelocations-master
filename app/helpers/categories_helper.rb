module CategoriesHelper
	def cache_key_for_category(category, key = nil)
		key ||= "#{controller_name}-#{action_name}"
		key << "-region-#{current_region}" unless current_region.nil?
		updated_at = category.updated_at.try(:utc).try(:to_s, :number)
    	"categories/#{current_site.id}-#{key}-#{category.id}-#{updated_at}"
    end
    
    
    def cache_key_for_categories(categories, key = nil)
		key ||= "#{controller_name}-#{action_name}"
		key << "-region-#{current_region}" unless current_region.nil?
		page = categories.current_page
		
		updated_at = categories.maximum(:updated_at).try(:utc).try(:to_s, :number)
    	"categories/#{current_site.id}-page-#{page}-#{key}-#{category.id}-#{updated_at}"
    end
	
	
	def view_change_select(view = nil)
		view ||= view_as
		_p = params.clone
		
		_p.delete(:site)
		
		_c = unless params[:default_controller].nil? then params[:default_controller] else params[:controller] end
		
		
		case view
			when :list
				#_p[:view_as] = :quick
				_path_helper = "quick_#{_c.to_s.gsub("controller","").singularize.downcase}_path".to_sym
				
				if respond_to?(_path_helper)
					link_to "Quick View", send(_path_helper,_p)
					
				end
				#_path_helper
			when :grid
				_path_helper = "#{_c.to_s.gsub("controller","").singularize.downcase}_path".to_sym
				if respond_to?(_path_helper)
					link_to "List View", send(_path_helper,_p)
				end
		end
	end
	    
end
