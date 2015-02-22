require "net/http"
require 'nokogiri'
require "uri"
require "benchmark"

namespace :precache do
	desc "Precache site"
	task :generate, [:site_id, :subdomain, :port]  => [:environment] do |t, args|
		include Rails.application.routes.url_helpers
		
			site_id = args[:site_id] || nil
			subdomain = args[:subdomain] || nil
			port = args[:port] || nil
			
			site = Site.find(site_id)
			
			abort if site.nil?
			
			
			
			
			Site.current = site
			
			
			host = site.hostname
			host = "#{subdomain}.#{host}" unless subdomain.blank?
			host << ":#{port}" unless port.nil?

						
			#Categories
			
			touch_url(categories_url(:host => host))
			
			
			Category.site(site_id).published().find_each do |c|
				
				touch_url(category_url(c, {:host => host}))
				
			end
			
			abort
			
			#Locations
			
			Location.site(site_id).published().find_each do |l|
				
				touch_url(location_url(l, {:host => host}))
				
			end
			
			#Publications
			touch_url(publications_url(:host => host))
			Publication.has_tears().find_each do |pub|
				
				touch_url(publication_url(pub, {:host => host}))
				
			end
			
			#Projects
			
			Project.site(site_id).published().find_each do |pro|
				
				touch_url(project_url(pro, {:host => host}))
				
			end
			
			
			puts "Touched #{@crawled.count} pages"
	end
	
	@crawled = []
	
	def touch_url(url, attempts = 0)
		
		return if @crawled.include?(url)
		
		uri = URI.parse(url)
		
		http = Net::HTTP.new(uri.host, uri.port)
		http.read_timeout = 500
			begin
				_valid_links = []
				time = Benchmark.measure do
					response = http.request(Net::HTTP::Get.new(uri.request_uri))
					@crawled.push(uri.to_s)
					
					if response.code == "200"
						_page = Nokogiri::HTML(response.body)
						
						_page.css("a").each do |anchor|
							_link = anchor[:href]
							
							_link = "#{uri.scheme}://#{uri.host}:#{uri.port}#{_link}" unless uri?(_link)
							
							next unless uri?(_link)
								
							
							unless anchor["data-type"].nil?
								
								_ext = anchor["data-type"] == "script" ? ".js" : ".json"
								
								_l2 = URI.parse(_link)
								_l2.path += _ext
								_link = "#{_l2.scheme}://#{_l2.host}:#{_l2.port}#{_l2.request_uri}"
								
							end
							
							_valid_links.push(_link) if !_valid_links.include?(_link) && URI.parse(_link).host == uri.host && !@crawled.include?(_link)
						end
					end
				end
				
				_valid_links.each {|l| touch_url(l)}
				puts "Touched #{uri.to_s}"
				puts time
			rescue Timeout::Error => e
				
				if attempts < 2
					attempts += 1
					sleep(30*attempts)
					touch_url(url, attempts)
				else
					puts "#{uri.to_s} timed out, after #{attempts}"
				end
			end
		
		sleep 10
	end
	
	def uri?(string)
	  uri = URI.parse(string)
	  %w( http https ).include?(uri.scheme)
	rescue URI::BadURIError
	  false
	rescue URI::InvalidURIError
	  false
	end

end