module RegionsHelper
	def region_weather_cache_key(region)
		updated_at = region.try(:utc).try(:to_s, :number)
		weather_updated_at = region.weather_timestamp.try(:utc).try(:to_s, :number) unless region.weather_timestamp.nil?
		"regions/weather-#{current_site.id}-#{region.id}-#{updated_at}-#{weather_updated_at}"
	end
	
	def cache_key_for_site_regions
		count = current_site.regions.count
    	max_updated_at = current_site.regions.maximum(:updated_at).try(:utc).try(:to_s, :number)
    	"sites/#{current_site.id}/regions/all-#{count}-#{max_updated_at}"
  end
end
