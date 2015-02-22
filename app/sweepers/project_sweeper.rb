class ProjectSweeper < ActionController::Caching::Sweeper
  observe Project
  
  def after_create(project)
    expire_cache_for project
  end
 
  def after_update(project)
    expire_cache_for project
  end
  

  def after_destroy(project)
    expire_cache_for project
  end
 
  
	def expire_cache_for(project)
		
		
		#expire_action(:controller => '/projects', :action => 'index')
		
		
		
    	#expire_action(:controller => '/projects', :action => 'show', :id => project)
    	
    	
    	#expire_fragment %r{projects/#{project.id}}
    	
    	#_slug = nil
    	
    	#unless project.current_entity.nil? || project.current_entity.slug.nil? || project.current_entity.slug.blank?
    	#	_slug = project.current_entity.slug
			
    	#end
    	
    	#expire_fragment %r{projects/#{_slug}} unless _slug.nil?
    	
    	
    	#unless project.company.nil?
			
		#	expire_fragment %r{projects/#{project.company.name.to_slug}/#{project.id}}
		#	expire_fragment %r{projects/#{project.company.name.to_slug}/#{_slug}} unless _slug.nil?
			

    	#end
	end
	
end