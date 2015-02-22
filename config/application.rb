require File.expand_path('../boot', __FILE__)

require 'rails/all'

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  Bundler.require(*Rails.groups(:assets => %w(development test)))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end

module Imagelocations
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    config.autoload_paths += %W(#{config.root}/lib/modules/)
    config.autoload_paths += %W(#{config.root}/lib/modules/**/)
    
    config.autoload_paths += %W(#{config.root}/app/sweepers/)
    
    config.autoload_paths += Dir["#{config.root}/lib/modules/**/*"]
    config.autoload_paths += Dir["#{config.root}/app/models/**/*"]
    
    config.middleware.insert_before "Warden::Manager", "SiteDispatcher"
    
    config.autoload_paths += %W(#{config.root}/middleware)
    
    #config.assets.paths << Rails.root.join('app', 'assets', 'fonts')
    
    config.assets.precompile += %w( pdf.css pdf.js )
    
    
    
    Dir.glob("#{config.root}/sites/*") do |folder|
    
    	_controller_path = "#{folder}/controllers"
    	_helper_path = "#{folder}/helpers"
		_asset_path = "#{folder}/assets"
		
		config.paths["app/helpers"] << _helper_path
		
		if !Dir.glob(_controller_path).empty?
			 config.autoload_paths += %W(#{_controller_path})
			 config.eager_load_paths += %W(#{_helper_path})
		end
		
		if !Dir.glob(_asset_path).empty?
			config.autoload_paths += %W(#{_asset_path})
			
			%w{stylesheets javascripts images fonts}.each do |dir|
				config.assets.paths += %W(#{_asset_path}/#{dir})
    		end 

			config.assets.precompile += ["#{File.basename(folder)}.css", "#{File.basename(folder)}.js"]
		end

    end
   
    
    config.allowed_per_page = [10, 20, 30]
    
    config.default_site_namespace = :imagelocations
    
    config.image_sizes = {
	    :admin => {
			:admin_thumb => [200, 200],
			:admin_large => [600, 800]
		}
    }
    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer
	config.active_record.observers = :site_entity_sweeper, :banner_entity_sweeper, :location_sweeper, :category_sweeper, :city_sweeper, :permit_sweeper, :region_sweeper, :tear_sweeper, :project_sweeper, :series_sweeper, :publication_sweeper
	
    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    # Enable escaping HTML in JSON.
    config.active_support.escape_html_entities_in_json = true
    
    config.payflow = {
  		:login => "imagelocations",
  		:user => "weddingestates",
  		:password => "T8KEKnJdx3eaDU",
  		:partner => "AmericanExpress",
  		:test => false,
  		:mock => false
  	}
  	
  	config.contacts = {
	  	:applications => "jason@imagelocations.com",
	  	:subscriptions => "payments@imagelocations.com"
  	}
  	
    # Use SQL instead of Active Record's schema dumper when creating the database.
    # This is necessary if your schema can't be completely dumped by the schema dumper,
    # like if you have constraints or database-specific column types
    # config.active_record.schema_format = :sql

    # Enforce whitelist mode for mass assignment.
    # This will create an empty whitelist of attributes available for mass-assignment for all models
    # in your app. As such, your models will need to explicitly whitelist or blacklist accessible
    # parameters by using an attr_accessible or attr_protected declaration.
    config.active_record.whitelist_attributes = true
	
    # Enable the asset pipeline
    config.assets.enabled = true
	config.assets.initialize_on_precompile = false
    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'
    
    config.use_ssl = false
    
  end
end
