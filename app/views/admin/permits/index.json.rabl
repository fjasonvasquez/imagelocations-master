object @permits
attributes :id, :name
node(:url) { |permit| admin_permit_path({ :id => permit.id, :site => @current_site.id }) }