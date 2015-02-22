class Admin::AdminController < ApplicationController
	layout 'admin'
	
	before_filter :authenticate_user!
	
	before_filter :accessible_roles
	before_filter :site_scope
    
    load_and_authorize_resource :only => [:index, :show, :create, :new, :destroy, :edit, :update]
    
    cache_sweeper :site_entity_sweeper, :only => [:create, :update, :reorder, :destroy]
    
    private
    def write_flash_to_cookie
    
    end
    
    def accessible_roles
    	#logger.debug(current_ability.inspect)
    	@accessible_roles = Role.admin_roles().accessible_by(current_ability,:read)
    end
    
    def allowed_per_page
    	[20,30,50,100]
    
    end
    
    def site_scope
    	#@current_site_location = current_site
    	
    	@original_site_id = current_site.id
    	
    	override_site = current_user.admin_site_memberships.find{ |s| s.id == params[:site].to_i} unless params[:site].nil?
		
	
		
		unless override_site.nil?
			
			override_site.subdomain = current_site.subdomain
		
			params[:site] = current_site.id if override_site.nil?
		
			@current_site = override_site unless override_site.nil? || override_site.id == current_site.id
			
			if @current_site.id != Site.current.id
				Site.current = @current_site
			end
		end
  		
  		
  		prepend_view_path("sites/#{@current_site.namespace}/views") unless @current_site.nil? || @current_site.default?
  		
  		#prepend_view_path("sites/#{@current_site.namespace}/views") unless @current_site.nil? || @current_site.default?
  		
  		super
  			
  	end
    
    
    
    def default_url_options(options = {})
    	options[:site] = params[:site]
    	options[:is_admin] = true
		options
  	end
end
