object @users
attributes :id, :full_name
node(:name) { |user| user.full_name }
node(:url) { |user| admin_user_path({ :id => user.id, :site => @current_site.id }) }