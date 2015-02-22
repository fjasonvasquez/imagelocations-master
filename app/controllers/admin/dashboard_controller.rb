class Admin::DashboardController < Admin::AdminController
  has_scope :site
  
  helper_method :top_locations
  helper_method :visits_this_week
  helper_method :visits
  
  respond_to :html, :json
  
  def index
	 
	  @loc_count = Location.all.count
	  
	  respond_to do |format|
      	format.html # new.html.erb
      	format.json { 
      		render(json: { 
      			:top_locations => top_locations ,
      			:visits_this_week => visits_this_week,
      			:visits => visits
      		})
      	}
	  end
	  
  end
  

  private
  
  def top_locations
  	get_stats[:top_locations] ||= begin
  		results = ga.dashboard(:filters => {:event_category.eql => "Locations", :event_action.eql => "View"}, :sort => "-event_value", :limit => 10).results
  		
  		[].tap do |o| 
  			results.each do |r|
  				l = apply_scopes(Location).find_by_id(r.event_label.to_i)
  				o << {:location => l.name, :views => r.event_value.to_i, :path => admin_location_path(l) } unless l.nil?
  			end
  		end
  	end unless ga.nil?
  end
   
  def visits_this_week
  	get_stats[:visits_this_week] ||= begin
  		today = DateTime.now
  		report_start = (today - 7.days)
  		count = 0
  		ga.day_visits(:end_date => today, :start_date => report_start ).results.each do |v|
  			count += v.visits.to_i
  		end
  		count
  	end unless ga.nil?
  
  end
  
  def visits
  	get_stats[:weekly_visits] ||= begin
  		today = DateTime.now
  		report_start = (today - 4.days)
  		@visits = [].tap do |o| 
  				ga.day_visits(:end_date => today, :start_date => report_start ).results.each_with_index do |v,i|
	  			o << { :x => (report_start).to_formatted_s(:year_month_day), :y => v.visits.to_i}
	  			report_start += 1.day
  			end
  		end
  	end unless ga.nil?
  end
  
  
  private
  
  def get_stats
 	_stats_key = "stats_#{current_site.id}".to_sym
 	
  	session[_stats_key] = nil if !session[_stats_key].nil? && (session[_stats_key][:timestamp] + 360 < Time.now.to_i)
  	
  	session[_stats_key] ||= { :timestamp => Time.now.to_i }
  	
  	session[_stats_key]
  end
  
  def ga
  	 @ga ||= begin
  	 	
  	 	 _auth = current_user.authentications.find_by_provider(:google_oauth2)
  	 	
  	 	unless _auth.nil?
	  	 	Garb.ca_cert_file = Rails.root.join('lib', 'curl', 'cacert.pem').to_s
	  	 	client = OAuth2::Client.new GOOGLE_CLIENT_ID, GOOGLE_CLIENT_SECRET,
	                                  {
	                                    :site => 'https://accounts.google.com',
	                                    :authorize_url => "/o/oauth2/auth",
	                                    :token_url => "/o/oauth2/token",
	                                  }
	        
	       
	        begin
	        	response = OAuth2::AccessToken.from_hash(client, :refresh_token => _auth.access_token).refresh!
	        	Garb::Session.access_token = response
	  	 	
				_ga = Garb::Management::Profile.all.detect {|p| p.web_property_id == current_site.google_tracking_id} unless current_site.google_tracking_id.nil?

				_ga
	        rescue OAuth2::Error => e
	        	
	        	if e.code == "invalid_grant"
	        		_auth.destroy
	        	end
				nil
	        end
	        
	  	 	
	  	 end
  	 end
  end

end
