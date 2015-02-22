module Admin::LocationsHelper
	def admin_formatted_location_name(location)
		
		
		unless location.current_entity.entity_title.blank?
			_name = "#{location.current_entity.entity_title}&nbsp<small class='text-muted'>(#{location.name})</small>"
			
		else
			_name = location.name
		
		end
		_name.html_safe
	end

	def location_status_filter_options
		{}.tap { |o| SiteEntity::SITE_ENTITY_STATUSES.each {|status| o.merge!({status => I18n.t(status)}) } }
	end
end