module ProjectsHelper

	def get_first_letter(string)
		letter = string[0,1].upcase
		letter = ("A".."Z").include?(letter) ? letter : "#"
	end
	
	def cache_key_for_project(project, key = nil)
		
		key ||= "#{controller_name}-#{action_name}"
		key << "-#{current_region.id}" if region_scope
		
		updated_at = project.updated_at.try(:utc).try(:to_s, :number)
    	"projects/#{current_site.id}-#{key}-#{project.id}-#{updated_at}"
    end
	
	
	def get_project_path(project)
		
		_params = { :id => project.slug.nil? ? project.id : project.slug }
		
		unless project.company.nil?
		
			company_project_path(_params.merge({:company_name => project.company.name.to_slug}))
		else
			project_path(_params)
		end
		
	end
	
	def project_link_title(project)	
		_locations_count = project.current_related_entities().count
		"#{project.name} (#{_locations_count})"
	end

end
