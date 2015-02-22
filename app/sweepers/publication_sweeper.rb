class PublicationSweeper < ActionController::Caching::Sweeper
  observe Publication
  
  def after_create(publication)
    expire_cache_for publication
  end
 
  def after_update(publication)
    expire_cache_for publication
  end
  

  def after_destroy(publication)
    expire_cache_for publication
  end
 
  
	def expire_cache_for(publication)
		
		expire_action(:controller => '/publications', :action => 'index', :params => { :site => Site.current} )
		expire_action(:controller => '/publications', :action => 'show', :id => publication, :params => {:site => Site.current})
		
		
		expire_fragment %r{publications?}
		
	end
end