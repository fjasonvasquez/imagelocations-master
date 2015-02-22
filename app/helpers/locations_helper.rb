module LocationsHelper
	
	def formatted_location_name(location, spacer = "&nbsp;", span = true, force_default = false)
		
		unless location.current_entity.entity_title.blank? || force_default
			location.current_entity.entity_title
		else	
			"#{location.series.name}".tap do |o|
				_open = (span == true) ? "<span>" : ""
				_close = (span == true) ? "</span>" : ""
				o << "#{spacer}#{_open}#{location.series_number.to_s.rjust(2, '0')}#{_close}" unless location.series_number.nil? || location.series_number == 0
			end.html_safe
		end
	end

	def cache_key_for_location(location, key = nil)
		key ||= "#{controller_name}-#{action_name}"
		key << "-#{current_region.id}" if region_scope
		
		updated_at = location.updated_at.try(:utc).try(:to_s, :number)
    	"locations/#{current_site.id}-#{key}-#{location.id}-#{updated_at}"
    end
    
end
