require 'action_dispatch/routing/route_set'
require 'active_support/dependencies'


module ActionDispatch
	
  module Routing
  	
    class RouteSet
      
      SITE_KEY = 'site'
            	
      class Dispatcher
      	include GlobalFunctions
      	
      	def call_with_site(env)
      		params = env[PARAMETERS_KEY]
      		params[:current_site] = env[:current_site] || nil
      		
      		call_without_site(env)
      	end

      	def controller_with_site_controller(params, default_controller=true)
	      	
	      	unless params[:current_site].nil? || params[:current_site][:namespace].blank?
	      		_fallback_controller = params[:controller]
	      		
		  		_site_controller = _fallback_controller.to_namespace_controller(params[:current_site][:namespace])
		  		
		  		params[:default_controller] = _fallback_controller
	      		params[:controller] = _site_controller
		  			
	      		begin
	      			_cont_name = "#{_site_controller.camelize}Controller"
	      			
	      			if controller_reference(_site_controller).name != _cont_name
	      				raise ActionController::RoutingError, "No namespaced matches"
	      			end
	      			
	      			controller_without_site_controller(params, default_controller)
	      		rescue ActionController::RoutingError, NameError => e
	      			params[:controller] = _fallback_controller
	      			
	      			controller_without_site_controller(params, default_controller)
          		end	
	      	else
	      		
	      		controller_without_site_controller(params, default_controller)
	      	end
	      	
	    end
	    
	    
	    alias_method_chain :controller, :site_controller
	    alias_method_chain :call, :site
	   	    
      end
      
      #save for later when we need to load 
      def url_for_with_subdomains(options, path_segments=nil)
		
		#site = options[:current_site]
		
		#ap options
		#unless site.subdomain.nil?
			
		#	options[:host] = site.subdomain
		
		#end		
		
		unless options[:controller].nil? || options[:controller].start_with?("admin/")
		
			options.delete(:site)
			#klass = options[:controller]"#{_site_controller.camelize}Controller"
		
		end
		
		unless options[:subdomain].nil?
			#ap options[:host]
			
		end
		
		unless options[:site].nil?
        	#options.delete(:site) if Site.current.id == options[:site] || !options[:is_admin]
        	options.delete(:site) if !options[:is_admin]
        end
		
        unless options[:default_controller].nil?
        	options[:controller] = options[:default_controller]
        end
        
        options.delete(:default_controller)
        options.delete(:current_site)
        options.delete(:is_admin)
        
        url_for_without_subdomains(options)
      end
      alias_method_chain :url_for, :subdomains
      
    end
  end
end
