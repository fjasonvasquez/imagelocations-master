class TearSweeper < ActionController::Caching::Sweeper
  observe Tear
  
  def after_create(tear)
    expire_cache_for tear
  end
 
  def after_update(tear)
    expire_cache_for tear
  end
  

  def after_destroy(tear)
    expire_cache_for tear
  end
 
  
	def expire_cache_for(tear)
		
		expire_action(:controller => '/home', :action => 'index', :params => { :site => Site.current})
		
		LocationSweeper.instance.expire_cache_for(tear.location)
		
		PublicationSweeper.instance.expire_cache_for(tear.publication) unless tear.publication.nil?
		
	end
end