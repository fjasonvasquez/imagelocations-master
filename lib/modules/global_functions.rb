#lib/global_functions.rb
module GlobalFunctions
	protected
	def remove_subdomain(host)
	    # Not complete. Add all root domain to regexp
	    host.sub(/.*?([^.]+(\.com|\.co\.uk|\.uk|\.nl))$/, "\\1")
	end
	
	def get_subdomain(host)
		_withoutsub = remove_subdomain(host)
		
		unless _withoutsub == host
			subdomain = host.sub(".#{_withoutsub}","")
		end
		
		subdomain ||= nil
	end
end