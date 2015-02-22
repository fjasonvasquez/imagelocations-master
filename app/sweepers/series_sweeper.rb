class SeriesSweeper < ActionController::Caching::Sweeper
  observe Series
  
  def after_create(series)
    expire_cache_for series
  end
 
  def after_update(series)
    expire_cache_for series
  end
  

  def after_destroy(series)
    expire_cache_for series
  end
 
  
	def expire_cache_for(series)
		
		expire_action(:controller => '/series', :action => 'index', :params => { :site => Site.current})    	
    	expire_action(:controller => '/series', :action => 'show', :id => series, :params => {:site => Site.current})
		
		expire_fragment %r{series?}
		
		expire_fragment %r{series/#{series.id}}
		
		series.locations.find_each do |l|
			LocationSweeper.instance.expire_cache_for(l)
		end
		
	end
end