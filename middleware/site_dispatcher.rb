class SiteDispatcher
	include GlobalFunctions
	
	def initialize(app)
		@app = app
	end
	
	def call(env)
		
		request = Rack::Request.new(env)
		
		env[:current_site] = get_site(request.host)
				
		if env[:current_site].subdomain.nil?
	  	
	  		[301, {"Location" => request.url.sub("//", "//www.")}, []]
	  	else
	  	    #Remove subdomain from cookies
	  	    #ap env["rack.session.options"]
	  	    #env["rack.session.options"][:domain] = ".#{env[:current_site].host.sub("www.", "")}"
	  	    env["rack.session.options"][:domain] = ".#{remove_subdomain(request.host)}"
	  		@app.call(env)
	  	end
		
	end
	
	
	def get_site(host)
		
	  	current_site = Site.by_hostname(remove_subdomain(host)) || Site.first_non_default
	  	
	  	current_site.subdomain = get_subdomain(host) unless current_site.nil?
	  	
	  	current_site
	 end
	 
end