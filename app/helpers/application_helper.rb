module ApplicationHelper
  
  def title(page_title = nil)
  	if page_title.present?
  		content_for :title, page_title.to_s
  	else
  	  unless admin?
      	content_for?(:title) ? current_site.name + ' | ' + content_for(:title) : current_site.name + ' | ' + current_site_setting(:site_title)
      else
      	content_for?(:title) ? content_for(:title) : ""
      end
    end
  end
  
  def meta_keywords(tags = nil)
    if tags.present?
      content_for :meta_keywords, tags
    else
      content_for?(:meta_keywords) ? [content_for(:meta_keywords)].join(', ') : current_site_setting(:meta_keywords)
    end
  end

  def meta_description(desc = nil)
    if desc.present?
      content_for :meta_description, desc
    else
      content_for?(:meta_description) ? content_for(:meta_description) : current_site_setting(:meta_description)
    end
  end
  
  def google_analytics_script
  	render(:partial => "shared/google_analytics_script", 
  			:locals => {
  				:tracking_id => current_site.google_tracking_id 
  			}
  	) unless current_site.google_tracking_id.blank?
  
  
  end
  
  def body_classes(body_class = nil)
  	
  	if body_class.present?
  		_s = body_class.to_s
  		if content_for?(:body_classes)
  			_s = " #{_s}"
  		end
  		content_for :body_classes, _s
  	
  	else
	  	[].tap do |o|
	  		_c_name = controller_name.sub("#{current_site.namespace}_","")
	  		o << _c_name
	  		o << action_name
	  		
	  		if content_for?(:body_classes)
	  			o << content_for(:body_classes)
	  		end
	  	end.join(" ")
	  	
	  	
	end
  end
  
  def is_home_page?
  	current_page? root_path
  
  end
  
  def render_message(type,msg)
    _class = type == :notice ? "success" : "error"
    _class = "alert-#{_class}"
  	if msg.is_a?(String)
  		content_tag(:div, :class => "alert #{_class}") do
	  		_html = '<a class="close" data-dismiss="alert" href="Javascript:void(0)">&#215;</a>'.html_safe
	  		_html << content_tag(:div, msg, :id => "flash_#{type}")
	  	end
	end
  end
  
  
  
  def avatar_url(user)
  	unless user.profile.avatar_url.nil? then user.profile.avatar_url else user.profile.gravatar_url({:default => image_url('admin/default_profile.png')}) end
  end
  
  def favicon_url(site = false)
  	 #site ||= @current_site
  	 
  	 if site.is_a?(Site)
	 	image_url "#{site.namespace}/favicon.png"
	 else
	 	image_url "favicon.png"
	 end
	 
  end
  
  def site_name
  	@current_site.name
  
  end
  
  def image_url(source)
		URI.join(root_url, image_path(source))
  end
  
  def params_for(path)
  	Rails.application.routes.recognize_path(path)
  end
  
  def new_object_from_association(f, association)
		new_object = f.object.class.reflect_on_association(association).klass.new
  end
  
  #image helpers
  
  
  def entity_image(entity,key)
  	
  	image = entity.current_image(key)
  end
  
  
  def format_temperature(temp)
  	"#{temp}&deg;".html_safe
  
  end
  
  def per_page_select(active_text = nil)
  	
  	
  	unless active_text.nil?
  		active_text = active_text.gsub("%s", params[:per_page].to_s)
  	else
  		active_text = params[:per_page]
  	end
  	
  	#select_tag :per_page, options_for_select(@allowed_per_page,:selected => params[:per_page]), :class => 'per-page span1 selectpicker'
  	render(:partial => "shared/per_page_select_field", :locals => {:allowed_per_page => @allowed_per_page, :per_page => params[:per_page], :active_text => active_text} )
  end
  
  
  def filter_select_field(param,text,options, args = {})
	active = false
	
	show_all = true unless !args[:show_all].nil? && !args[:show_all]
	prepend_text = args[:prepend_text] unless args[:prepend_text].nil? || !args[:prepend_text]
	classes = args[:classes].nil? ? "btn-small" : args[:classes]
	icon = args[:icon].nil? ? "icon-caret-down" : args[:icon]
	filter_params = params.clone
	@filtered_params ||= []

  	if !filter_params[param].nil? && !options[filter_params[param]].nil?
  		active = filter_params[param]
  		text = options[active]
  		filter_params.delete(param)
  		@filtered_params.push(param)
  	end
  	
  	text = "#{prepend_text}<span>#{text}</span>".html_safe unless prepend_text.nil?
  	
  	render(:partial => "shared/filter_select_field", :locals => {:param => param, :filter_params => filter_params,:text => text, :options => options, :active => active, :show_all => show_all, :classes => classes, :icon => icon} ) unless options.nil?
  end
  
  def filter_clear_field
  	unless @filtered_params.empty?
  		filter_params = params.clone
  		filter_params.delete_if {|p| @filtered_params.include?(p)}
  		content_tag :div, :class => "btn-group" do
  			link_to(content_tag(:i,"",:class => "icon-remove-sign"),filter_params, :class => "btn btn-small")
  		end
  	end
  end
  
  
end
