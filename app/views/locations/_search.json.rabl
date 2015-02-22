object @locations
attributes :id, :name
node(:url) { |location| location_path(location) }

node(:total) {|m| @locations.total_count }

