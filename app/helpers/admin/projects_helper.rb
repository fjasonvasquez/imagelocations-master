module Admin::ProjectsHelper
	def project_companies_filter_options  		
  		{}.tap { |o| Company.has_project.all.each.map {|company| o.merge!({company.id.to_s => company.name})} }
  	end



end
