class PermitSweeper < ActionController::Caching::Sweeper
  observe Permit
  
  def after_create(permit)
    expire_cache_for permit
  end
 
  def after_update(permit)
    expire_cache_for permit
  end
  

  def after_destroy(permit)
    expire_cache_for permit
  end
 
  
	def expire_cache_for(permit)
		
		expire_action(:controller => '/permits', :action => 'index', :params => { :site => Site.current.id})    	
    	expire_action(:controller => '/permits', :action => 'show', :id => permit, :params => {:site => Site.current.id})
		
		
		
		permit.locations.find_each do |l|
			LocationSweeper.instance.expire_cache_for(l)
		end
		
	end
end