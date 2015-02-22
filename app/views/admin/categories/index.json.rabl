object @categories
attributes :id, :name
node(:url) { |category| admin_category_path({ :id => category.id, :site => @current_site.id }) }