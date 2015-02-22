module SiteDomain
	class DomainConstraint
	  def initialize(site_id)
	  		#ap domain
			@site_id = site_id
	  end
	
	  def matches?(request)
	  	
	    @site_id == request.env[:current_site][:id]
	  end
	
	end


end