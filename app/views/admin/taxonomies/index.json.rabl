object @taxonomies
attributes :id, :name
node(:url) { |taxonomy| admin_taxonomy_path({ :id => taxonomy.id, :site => @current_site.id }) }