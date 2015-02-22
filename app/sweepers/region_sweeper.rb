class RegionSweeper < ActionController::Caching::Sweeper
  observe Region
  
  def after_create(region)
    expire_cache_for region
  end
 
  def after_update(region)
    expire_cache_for region
  end
  

  def after_destroy(region)
    expire_cache_for region
  end
 
  
	def expire_cache_for(region)
		
		expire_action(:controller => '/home', :action => 'index', :params => { :site => Site.current})
		
		expire_action(:controller => '/categories', :action => 'index', :params => { :site => Site.current, :region => region})
		
		expire_fragment %r{.*}
	end
end