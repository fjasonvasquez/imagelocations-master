object @cities
attributes :id, :name, :full_name
child(:state) { attributes :name, :country_alpha2 }