class SiteEntitySweeper < ActionController::Caching::Sweeper
  observe SiteEntity
  
  def after_create(entity)
    expire_cache_for entity
  end
 
  def after_update(entity)
    expire_cache_for entity
  end
  

  def after_destroy(entity)
    expire_cache_for entity
  end
 
  private
    def expire_cache_for(entity)
    	
    	expire_action(:controller => '/home', :action => 'index', :params => { :site => Site.current})
    	
    	expire_action(:controller => '/categories', :action => 'index', :params => { :site => Site.current})
    end
end