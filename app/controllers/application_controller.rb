#require 'global_functions'
#TEST
class ApplicationController < ActionController::Base
  include PublicActivity::StoreController
  include GlobalFunctions
  
  protect_from_forgery
  
  helper_method :site
  helper_method :current_site
  helper_method :current_site_setting
  helper_method :current_site_settings
  helper_method :user_is_subscribed?
  
  helper_method :referer_path
  
  helper_method :region_scope
  
  helper_method :view_as
  helper_method :has_views
  
  before_filter :set_per_page
  before_filter :region_scope
  before_filter :current_site
  before_filter :site_scope
  
  before_filter :view_as
  
  
  
  #before_filter :set_region
  helper_method :current_region
  
  helper_method :searched_string
  
  layout :site_layout
  
  after_filter :write_flash_to_cookie
  
  
  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] = "Access denied. You are not authorized to access the requested page."
    redirect_to root_path and return
  end
  
  #include GlobalFunctions
  #include SiteDispatcher
  #def current_user
  #	super
    #@current_user ||= User.find(session[:user_id]) if session[:user_id]
  #end
  
  #helper_method :current_user
  #hide_action :current_user
  #def controller_name
  		
   #   self.class.controller_name
  #end
  
  # def after_sign_in_path_for(resource)
#     sign_in_url = url_for(:action => 'new', :controller => 'sessions', :only_path => false, :protocol => 'http')
#     if request.referer == sign_in_url
#       super
#     else
#       stored_location_for(resource) || request.referer || root_path
#     end
#   end
  

	
  protected
  
  	def self.permission
    	return name = self.name.gsub('Controller','').singularize.split('::').last.constantize.name rescue nil
    end
    
    def user_is_subscribed?
		current_user and current_user.is_subscribed?
	
	end
	
	def user_is_admin?
	    current_user and current_user.current_site_roles.admin_roles.any?
	end
    
  private
  	def set_per_page
    	@allowed_per_page = allowed_per_page || Rails.configuration.allowed_per_page

    	params[:per_page] = params[:per_page].to_i
    	params[:per_page] = nil unless @allowed_per_page.include? params[:per_page]
    	params[:per_page] ||= Kaminari.config.default_per_page
    	
    end
    
    def allowed_per_page
    
    end
    
    def has_views
    
    end
    
  	def view_as
  		@view_as ||= begin
  			_view_as = if params[:view_as] then params[:view_as] else :list end
  			params.delete(:view_as)
  			_view_as
  		end
  	
  	end
  
    def write_flash_to_cookie
	    cookie_flash = cookies['flash'] ? JSON.parse(cookies['flash']) : {}
	
	    flash.each do |key, value|
	    	value = view_context.render_message(key,value)
	        if cookie_flash[key.to_s].blank?
	            cookie_flash[key.to_s] = value
	        else
	            cookie_flash[key.to_s] << "<br/>#{value}"
	        end
	     end
	
	    cookies['flash'] = cookie_flash.to_json
	    flash.clear
	end
	
	def site_layout
	  	!current_site.namespace.empty? && lookup_context.exists?(current_site.namespace, "layouts") ? current_site.namespace.to_s : "application"
	end
	
	
	def site_scope
		@site_scope ||= begin
			params[:site] = current_site.id unless current_site.nil?
			Site.current = current_site
		end
  	end
  	
	def current_site
		
        @current_site ||= begin
        	_site = params[:current_site]
        	prepend_view_path("sites/#{_site.namespace}/views") unless _site.nil? || admin?
        	_site
        end
    end
	

	def current_site_settings
		@current_site_settings ||= {}.tap do |o|
			
			current_site.settings.find_each {|s| o[s.key.intern] = s}
		
		end
	end
	
	def current_site_setting(key)
		unless current_site_settings[key].nil?	
			current_site_settings[key].value
		end	
	end
	
	
	def current_ability
      @current_ability ||= Ability.new(current_user, current_site, admin?)
    end
    
	def set_region
		
		@current_region ||= begin 
		
			_current_region = current_site.regions.current(params[:region] || nil)
			@current_region_scoped = params[:region].nil?
			
			params[:region] = _current_region.nil? ? nil : _current_region.id.to_s
			
			params.delete(:region) if @current_region_scoped
			
			_current_region
		end
	end
	
	def current_region
		
        @current_region || set_region
    end
    
    def region_scope
    	if @region_scope.nil?
	    	@region_scope = if params[:region].nil? then FALSE else params[:region] end
	    end
    	@region_scope
    end
    
    def default_url_options(options = {})
    	
		_opts = {:host =>  current_site.host }
		_opts[:region] = params[:region] unless !region_scope || params[:region].nil?

		_opts
				
  	end
  	
  	def referer_path
  		
  		begin
  			_uri = URI(request.referer).path
  			_path = _uri.path
  			Rails.application.routes.recognize_path(_path)
  			_path
  		rescue
  			root_path
  		end
  	end
  	
  	def searched_string
  		@searched_string ||= current_scopes[:search] unless current_scopes[:search].nil? || current_scopes[:search].blank?
  	end
  	
  	def admin?
    	self.class.to_s.split("::").first=="Admin"
	end
	
	
	def default_url_options
		_options = {}
		
		_options[:host] ||= current_site.host unless admin?
		
		_options[:is_admin] = false
		_options[:controller] = params[:default_controller] unless params[:controller].nil? || params[:default_controller].nil?
		
		_options[:region] = region_scope unless !region_scope
		
		_options
		
	end
	
	
	
	
	
	
end