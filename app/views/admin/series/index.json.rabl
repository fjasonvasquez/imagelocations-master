object @series
attributes :id, :name, :next_series_number, :series_numbers, :series_numbers_sites
node(:url) { |series| admin_series_path({ :id => series.id, :site => @current_site.id }) }