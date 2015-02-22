object @locations
attributes :id, :name, :series_number
node(:add_as_similar_url) { |location| new_similar_admin_location_path(location) }
node(:url) { |location| admin_location_path(location) }