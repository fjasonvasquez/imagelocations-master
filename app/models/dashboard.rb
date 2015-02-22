class Dashboard < ActiveRecord::Base
	extend Garb::Model
	
	
	
	metrics :event_value, :visits_with_event, :exits, :pageviews, :visits
	dimensions :event_category, :event_action, :event_label, :page_path
end

class TopLocations
	extend Garb::Model
	
	metrics :event_value, :visits_with_event, :exits, :pageviews, :visits
	dimensions :event_category, :event_action, :event_label, :page_path
end

class DayVisits
	extend Garb::Model
	metrics :visits
	dimensions :day
end

class WeekVisits
	extend Garb::Model
	metrics :visits
	dimensions :week
end