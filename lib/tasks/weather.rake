desc "Update weather from Forcast.IO"
task :weather => :environment do
	Region.find_each do |r|
		r.set_weather_forecast
		puts "Updated #{r.name}"
	end
end