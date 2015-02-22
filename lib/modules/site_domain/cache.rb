module ActionController #:nodoc:
  module Caching
    module Fragments
    
    	#add current site id to cache key to seperate caches by domain
   		def fragment_cache_key_with_site(key)
      		
      		fragment_cache_key_without_site(key)
      		
      		
      	end

	    alias_method_chain :fragment_cache_key, :site    
    end
  end
end
