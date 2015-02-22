class Admin::SettingsController < Admin::AdminController
	
	respond_to :html, :xml, :json
	
	before_filter :current_controller_settings
	
	helper_method :controllers_settings
	helper_method :current_controller_settings
	
	has_scope :by_controller
	
	def index
		
		
		
		@settings = apply_scopes(current_site.settings)
		
		respond_with @settings
	end
	
	
	def update
	    if current_site.update_attributes(params[:current_site_settings])
	      redirect_to admin_settings_path, :notice => "site updated."
	    else
	      redirect_to admin_settings_path, :alert => "Unable to update site."
	    end

	
	end
	
	private
	
	def current_controller_settings
		
		@current_controller_settings ||= params[:by_controller].nil? ? controllers_settings.first : params[:by_controller].to_sym
		
		
	end
	
	def controllers_settings
		@controllers_settings ||= current_site.settings.controllers.map {|c| c.controller_name}
	
	end
	

end
