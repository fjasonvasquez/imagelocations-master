class LocationSweeper < ActionController::Caching::Sweeper
  observe Location
  
  def after_create(location)
    expire_cache_for location
  end
 
  def after_update(location)
    expire_cache_for location
  end
  

  def after_destroy(location)
    expire_cache_for location
  end
 
  
	def expire_cache_for(location)
		
		expire_action(:controller => '/home', :action => 'index')
		
		#expire_action(:controller => '/locations', :action => 'index', :params => {:site => Site.current})
		expire_action(:controller => '/locations', :action => 'show', :id => location)
		
		expire_fragment %r{locations/#{location.id}}
		
		unless location.categories.nil?
			expire_action(:controller => '/categories', :action => 'index')    	
	    	expire_fragment %r{categories?}
	    	
			location.categories.each do |c|
				
				expire_fragment %r{categories/#{c.id}}
				
				#CategorySweeper.instance.expire_cache_for(c)
				expire_action(:controller => '/categories', :action => 'show', :id => c)
			end
		end
		
		unless location.city.nil?
			expire_fragment %r{cities?}
			expire_fragment %r{cities/#{location.city.id}}
		end
		
		expire_fragment %r{series?}
		
		expire_fragment %r{series/#{location.series.id}}
		
	end
end