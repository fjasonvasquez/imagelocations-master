require 'active_support/inflector'
require 'cgi'
require 'uri'

module Admin::AdminHelper
	
	def admin?
    	controller.class.name.split("::").first == "Admin"
    end
	
	def paginate(scope, options = {}, &block)
      options[:theme] = "admin" if admin? && options[:theme].nil?
      super(scope, options, &block)
    end
	
	def search_form(model,label = nil)
		label = label.nil? ? model.name.pluralize : label
		base = model.name.underscore
		logger.debug base
		form_tag '', :method => :get, :class => "navbar-form pull-left navbar-search form-search" do
			content_tag :div, :class => "input-append" do
				_content = hidden_field_tag(:site, params[:site]) 
				_content << search_field_tag("search", params[:search], :class => 'search-query', :placeholder => "Search #{label}", :data => {:type => "search", :base => base})
				_content << '<button type="submit" class="btn btn-inverse"><i class="icon-search"></i></button>'.html_safe
				_content
			end
		end	
	end
	
	def url_for(options = {})
		if options.is_a?(Hash) && !admin?
			options.delete(:site)
		end
		super(options)
	end
	
	
	def link_to(*args, &block)
		if admin?
			index = 0
			unless block_given?
				index = 1			
			end
				
			options = args[index] || {}
			
			url = url_for(options)
			
			site = params[:site] unless params[:site].nil?
			
			uri = URI.parse(url)
	
			q = {}
			q = CGI.parse(uri.query) unless uri.query.nil?
			
			q[:site] = site if q[:site].nil? && !site.nil?
			
			begin
				uri.query = URI.encode_www_form(q)
				args[index] = uri.to_s unless q.empty? || url[0].chr == "#" || site == @current_site_location.id
			rescue
			
			end
		end
		super(*args, &block)
	end
	def site_entity_builder(builder = false)
		
		@site_entity_builder = nil if builder
		
		@site_entity_builder ||= builder
	end
	def site_entity_action_tab_classes(site_entity)
		[].tap do |c|
			c << 'tab-pane'
			c << 'active' if @current_site == site_entity
		end
	end
	
	def site_entity_action_bar_classes
		[].tap do |c|
  			c << "pull-right"
  			c << "nav-entity-actions"
  			c << 'hide' if @current_site.id == 0
  		end

	end
	
	
	def site_entity_prefix(entity)
		entity_id = entity.id.nil? ? "new" : entity.id
		"#{entity.class.name.underscore}-#{entity_id}"
	end
	def site_entity_tab_content_id(site_entity)
		entity_id = site_entity.site_entitable_id.nil? ? "new" : site_entity.site_entitable_id
		
		"#{site_entity.site_entitable_type.underscore}-#{entity_id}-site-#{site_entity.site.id}"
	end
  	def site_entity_drop_classes(site_entity)
  		[].tap do |c|
  			c << 'site-dropdown'
  			c << "site-#{site_entity.site.id}"
  			c << 'hide' unless site_entity.id.nil?
  		end
  	end
  	
  	def site_entity_tab_classes(site_entity)
  		[].tap do |c|
  			c << 'site-tab'
  			c << "site-#{site_entity.site.id}"
  			c << "new" if site_entity.new_record?
  			c << 'active' if @current_site == site_entity.site
  			c << 'hide' if site_entity.id.nil? && !site_entity.site.default? && @current_site != site_entity.site
  		end
  	end
  	
	def format_membership_name(membership)
		site_name = membership.site.nil? ? "All" : membership.site.name
		icon = favicon_url(membership.site)
		
		
		#html << HTML
		content_tag :span, :class => 'label' do
			content_tag(:i, image_tag(icon),:class => 'icon-white') +
			escape_once(membership.role.label)
		end
		#'#{membership.role.label} - <small>#{site_name}</small>')
		#raw("<span class='label'></span>")
	end
	
	def count_tag(count)
  		
  		count_class = ['badge']  		
  		
  		case
  			when count < 1
  				count_class << 'badge-important'
  			when count > 9
  				count_class << 'badge-success'
  			
  		end
  		
  		content_tag(:span, count, :class => count_class.join(" "))
  	end	

	def status_tag(status)
  		
  		status_class = ['label']
  		status = status.to_sym
  		
  		
  		case status
  			when :active, :published, :complete
  				status_class << 'label-success'
            when :banned, :expired, :onhold, :suspended
  				status_class << 'label-important'
  			
  		end
  		
  		content_tag(:span, I18n.t(status), :class => status_class.join(" "))
  	end
	
	def nav_active(path)
		"active".html_safe if current_page?(path)
	end
	
	def nav_tab_link(options)

	  link_text = options[:text]
	  link_params = Hash.new
	  class_name = current_page?(options[:path]) ? ["active"] : []
	  	  
	  class_name = class_name.join(" ")
  	  content_tag(:li, :class => class_name) do
  	  	  
	  	  content = link_to options[:path],link_params do
	  	  	content = ""
	  	  	content = content_tag(:i,'',:class => "#{options[:icon]}").html_safe unless options[:icon].nil?
	  	  	content << link_text.html_safe
	  	  	
	  	  end
	  	  	  	  
	  	  content
	  end
  end


	def nav_link(options)
	  
	  if options[:permission].nil? || can?(:read, options[:permission])
		  link_text = options[:text]
		  link_params = Hash.new
		  link_permission = options[:permissions]
		  class_name = (current_page?(options[:path]) || "#{link_params[:controller]}_controller".camelize == controller.class.name) ? ["active"] : []
		    
		  sub_links = options[:sub_links] unless options[:sub_links].nil?
		  
		  unless sub_links.nil?
		  	  class_name << "lp-dropdown"
		  	  dropdown_id = "#{link_text}-dropdown".underscore.dasherize
		  	
		  	  link_params[:class] = "lp-dropdown-toggle"
		  	  link_params[:id] = dropdown_id
		  	  
			  sub_link_html = content_tag(:ul, :class => ["lp-dropdown-menu"],:data => {"dropdown_owner" => dropdown_id}) do
			  	  ul = []
			  	  sub_links.each do |l|
			  	
		  	  	 	class_name << "active" if current_page?(l[:path])
		  	  	 	l = nav_link(l)
		  	  	 	ul << l unless l.nil?
		  	  	 	
				  end
				  
				  sub_links = nil if ul.empty? 
			  	  ul.join(" ").html_safe
			  end
		  end
		  
		  if !options[:permission].nil? || !sub_links.nil?
		  
			  if "#{link_params[:controller]}_controller".camelize == controller.class.name
			  	class_name << "active"
			  end
			  class_name = class_name.join(" ")
		  	  content_tag(:li, :class => class_name) do
		  	  	  
			  	  content = link_to options[:path],link_params do
			  	  	content = ""
			  	  	content = content_tag(:i,'',:class => "#{options[:icon]}").html_safe unless options[:icon].nil?
			  	  	content << link_text.html_safe
			  	  	
			  	  end
			  	  content << sub_link_html
			  end
		  end
	  end
  end
  
	def destroy_link_to(content, path, options)
	  link_to(content, path, 
	    :method => :delete,
	    :class => options[:class].nil? ? "btn btn-danger btn-mini" : options[:class],
	    :confirm => t('destroy_confirm.body', :item => options[:item]),
	    "data-confirm-title" => t('destroy_confirm.title', :item => options[:item]),
	    "data-confirm-cancel" => t('destroy_confirm.cancel', :item => options[:item]),
	    "data-confirm-proceed" => t('destroy_confirm.proceed', :item => options[:item]),
	    "data-confirm-proceed-class" => "btn-danger")
	end
	
	def destroy_button_to(content, path, options)
	  button_to(content, path, 
	    :method => :delete,
	    :class => options[:class].nil? ? "btn btn-danger btn-mini" : options[:class],
	    :confirm => t('destroy_confirm.body', :item => options[:item]),
	    "data-confirm-title" => t('destroy_confirm.title', :item => options[:item]),
	    "data-confirm-cancel" => t('destroy_confirm.cancel', :item => options[:item]),
	    "data-confirm-proceed" => t('destroy_confirm.proceed', :item => options[:item]),
	    "data-confirm-proceed-class" => "btn-danger")
	end
	
	
	def whose?(user, object)
    case object
      when Location
        owner = object.author
      when Comment
        owner = object.user
      else
        owner = nil
    end
    if user and owner
      if user.id == owner.id
        "his"
      else
        "#{owner.nickname}'s"
      end
    else
      ""
    end
  end

  # Check if object still exists in the database and display a link to it,
  # otherwise display a proper message about it.
  # This is used in activities that can refer to
  # objects which no longer exist, like removed posts.
  def link_to_trackable(object, object_type)
    if object
      link_to object_type.downcase, object
    else
      "a #{object_type.downcase} which does not exist anymore"
    end
  end
  
  def table_thumb(entity)

  	if image = entity_image(entity,:cover) 		
  			image_tag image.source_url(:tiny), :class => :cover
  		else
  			holder_tag "40x40", 'None'
  		end
  
  end

  
  def link_to_add_related_entity_fields(name, f, association, partial)
		new_object = f.object.class.reflect_on_association(association).klass.new
		new_object.build_related_entity
		id = new_object.object_id
		logger.debug association.to_s.singularize
		fields = f.fields_for(association, new_object, :child_index => id) do |builder|
			if partial.nil?
				render("admin/shared/" + association.to_s.singularize + "_fields", :f => builder)
			else
				render("admin/shared/" + partial, :f => builder)
			end
		end
		
		#link_to_function(name, h("add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")"))
		link_to name, "#", :class => "add_#{association.to_s.singularize} btn disabled", 
							:data => {
								:id => id, 
								:template => fields.gsub("/n",""),
								:loading_text => "Loading..."
							}
  end
  
  
end
