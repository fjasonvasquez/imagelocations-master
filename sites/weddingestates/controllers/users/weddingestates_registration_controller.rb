class Users::WeddingestatesRegistrationController < Users::RegistrationController
	def new
		
		build_resource({})
		
		self.resource.build_profile
		
		@plan = Plan.site(current_site).saleable().order("plans.price asc").first
		
		@promo_code = @plan.promo_codes.find_by_code("facebook") unless @plan.nil?
		
		unless session[:promo_code].nil?
			
			@plan.current_promo_code = @plan.promo_codes.find(session[:promo_code])
		end
		
		
		respond_with self.resource
		 
	end
	
	
	def edit
		super
		

		
	end
	


end
