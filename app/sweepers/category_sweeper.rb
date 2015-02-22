class CategorySweeper < ActionController::Caching::Sweeper
  observe Category
  
  def after_create(category)
    expire_cache_for category
  end
 
  def after_update(category)
    expire_cache_for category
  end
  

  def after_destroy(category)
    expire_cache_for category
  end
 
  #private
    def expire_cache_for(category)
    	
    	expire_action(:controller => '/categories', :action => 'index', :params => { :site => Site.current.id})    	
    	expire_action(:controller => '/categories', :action => 'show', :id => category, :params => {:site => Site.current.id})
    	
    	expire_fragment %r{categories?}
    	
    	expire_fragment %r{categories/#{category.id}}
    	
    end
end