class CitySweeper < ActionController::Caching::Sweeper
  observe City
  
  def after_create(city)
    expire_cache_for city
  end
 
  def after_update(city)
    expire_cache_for city
  end
  

  def after_destroy(city)
    expire_cache_for city
  end
 
  
	def expire_cache_for(city)
		
		
		expire_action(:controller => '/cities', :action => 'index', :params => { :site => Site.current})    	
    	expire_action(:controller => '/cities', :action => 'show', :id => city, :params => {:site => Site.current})
		
		city.locations.find_each do |l|
			LocationSweeper.instance.expire_cache_for(l)
		end
		
	end
end