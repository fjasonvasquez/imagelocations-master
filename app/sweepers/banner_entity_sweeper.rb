class BannerEntitySweeper < ActionController::Caching::Sweeper
  #include ActionController::Caching::Pages
  
  observe BannerEntity
  
  def after_create(banner_entity)
    expire_cache_for banner_entity
  end
 
  def after_update(banner_entity)
  	
    expire_cache_for banner_entity
  end
  
  
  def after_destroy(banner_entity)
    expire_cache_for banner_entity
  end
 
  private
    def expire_cache_for(banner_entity)

      expire_action(:controller => '/home', :action => 'index')
      expire_action(:controller => '/categories', :action => 'index')
      
      expire_fragment %r{home?}
      expire_fragment %r{projects/\d*}
      
      expire_fragment %r{projects/\s*/}
      expire_fragment %r{categories?}
      
      expire_fragment "sections/#{Site.current.id}-#{banner_entity.section.key}"
      
    end
end