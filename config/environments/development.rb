Imagelocations::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false
  
  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true
  
  
  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false
  
  #config.cache_store = :file_store, "/home/mailoarsac/imagelocations/tmp/cache"

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = true
  #config.action_mailer.delivery_method = :sendmail
  config.action_mailer.perform_deliveries = true
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
	  address:              'smtp.gmail.com',
	  port:                 587,
	  domain:               'geosith.com',
	  user_name:            'mailo.arsac',
	  password:             'ping1234!@#',
	  authentication:       'plain',
	  enable_starttls_auto: true  }  
  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log
  
  config.default_site_namespace = :imagelocations

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Raise exception on mass assignment protection for Active Record models
  config.active_record.mass_assignment_sanitizer = :strict

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  config.active_record.auto_explain_threshold_in_seconds = 0.5

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = false
  
  #Uncomment the following line to turn asset logging back on
  #config.quiet_assets = false
  config.reload_plugins = true
  
  config.action_mailer.default_url_options = { :host => '192.168.1.5:3000' }
  
  config.watchable_dirs['#{Rails.root}/lib/modules'] = [:rb]
  
  config.sass.load_paths << "#{Gem.loaded_specs['compass'].full_gem_path}/frameworks/compass/stylesheets"
  
  config.ignore_domain = true
  
  config.payflow = {
  		:login => "imagelocations",
  		:user => "weddingestates",
  		:password => "T8KEKnJdx3eaDU",
  		:partner => "AmericanExpress",
  		:test => true,
  		:mock => false
  	}
  
  
  config.contacts = {
	  	:applications => "mailo.arsac@geosith.com",
	  	:subscriptions => "mailo.arsac@geosith.com"
  }
   config.after_initialize do
 	  Bullet.enable = false
 	  Bullet.alert = false
 	  Bullet.bullet_logger = false
 	  Bullet.console = false
 	  Bullet.growl = false
 	  Bullet.rails_logger = false
 	  Bullet.airbrake = false
 	  Bullet.add_footer = false
   end
   
   config.use_ssl = true
   
   
   #config.action_controller.asset_host = "//cdn.imagelocations.com"
   
end

#don't allow rails to cache the custom modules
ActiveSupport::Dependencies.explicitly_unloadable_constants << 'SiteDomain'
ActiveSupport::Dependencies.explicitly_unloadable_constants << 'Filtering::Helper'
