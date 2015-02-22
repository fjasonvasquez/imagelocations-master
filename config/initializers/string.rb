class String
	def to_slug
	    # Perform transliteration to replace non-ascii characters with an ascii
	    # character
	    value = self.mb_chars.normalize(:kd).gsub(/[^\x00-\x7F]/n, '').to_s
	    
	    # Remove single quotes from input
	    value.gsub!(/[']+/, '')
	
	    # Replace any non-word character (\W) with a space
	    value.gsub!(/\W+/, ' ')
	    
	    # Remove any whitespace before and after the string
	    value.strip!
	    
	    # All characters should be downcased
	    value.downcase!
	    
	    # Replace spaces with dashes
	    value.gsub!(' ', '-')
	    
	    # Return the resulting slug
	    value
	end
	
	
	def remove_subdomain
	    # Not complete. Add all root domain to regexp
	    _v = self.sub(/.*?([^.]+(\.com|\.co\.uk|\.uk|\.nl))$/, "\\1")
	    _v
	end
	
	def get_subdomain
		_withoutsub = self.remove_subdomain()
		
		unless _withoutsub == self
			subdomain = self.sub(".#{_withoutsub}","")
		end
		
		subdomain ||= nil
	end
	
	
	def to_namespace_controller(namespace)
	
		_insert_index = 0
		
		_insert_string = "#{namespace}_"
		
		_cont = self.clone
	
		if self.include? "/"
	      	_insert_index = self.rindex("/") + 1
	      	
	    end
	    
	    _cont.insert(_insert_index, _insert_string)
	end
end