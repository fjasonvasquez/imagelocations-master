module HomepageBannersHelper
	def cache_key_for_section(section)
    	"sections/#{current_site.id}-#{section}"
	end

end
