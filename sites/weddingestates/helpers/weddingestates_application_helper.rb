module WeddingestatesApplicationHelper
	
	def bg_slides(images = nil, &block)
		if images.present?
			content_for :bg_images, render(:partial => "shared/slides", :locals => {:slides => images, :block => block_given? ? block : nil})
		else
			
			#javascript_tag do
			#	data =  content_for?(:bg_images) ? content_for(:bg_images) : "[]".html_safe
			#	"bgSlides = #{data};".html_safe
			#end
			
			content_for?(:bg_images) ? content_for(:bg_images) : ""
		end
	end
	
	def is_private_page?
		(!user_is_subscribed? && !params[:private].nil?) || user_is_subscribed?
	
	end
	
	def has_bg_slides?
		content_for?(:bg_images)
	end
	
	def main_container_classes(container_class = nil)
  	
	  	if container_class.present?
	  		_s = container_class.to_s
	  		if content_for?(:container_class)
	  			_s = " #{_s}"
	  		end
	  		content_for :container_class, _s
	  	
	  	else
			content_for(:container_class)
		end
	end
end