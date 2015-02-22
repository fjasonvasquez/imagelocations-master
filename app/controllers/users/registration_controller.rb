class Users::RegistrationController < Devise::RegistrationsController
	before_filter :remove_membership_attributes, :only => [:create, :update]

	def new
		
		 build_resource({})
		 
		 self.resource.build_profile
		 
		 respond_with self.resource
		 
	end
	
	def create
		
		super
		
		UserMailer.welcome_email(@user).deliver unless @user.invalid?
	
	end
	
	protected
	
	def remove_membership_attributes
		params[:user].delete(:memberships_attributes)
		
	end
	
	def sign_up_params
    	devise_parameter_sanitizer.sanitize(:sign_up)
    end

  	def account_update_params
  		devise_parameter_sanitizer.sanitize(:account_update)
  	end
end
