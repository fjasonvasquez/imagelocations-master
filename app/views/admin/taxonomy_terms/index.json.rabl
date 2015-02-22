object @taxonomy_terms
attributes :id, :name
node(:url) { |taxonomy_term| admin_taxonomy_term_path({ :id => taxonomy_term.id, :site => @current_site.id }) }