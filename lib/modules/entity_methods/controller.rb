require 'active_support/concern'

module EntityMethods
	module Controller
	  extend ActiveSupport::Concern
	  included do
	  	  hide_action :remove_site_scope?
	  	  has_scope :site, :unless => proc{ |e| e.remove_site_scope? && e.params[:action] != "show" }
	  	  has_scope :by_status
	  	  
		  before_filter :process_site_attrs, only: [:create, :update]
		  	  
	  end
	  
	  
	  def remove_site_scope?
	  		false
	  end
	  
	  private
	  
	  	def set_site_entities(relation)
	  		
	  		@site_entity = relation.site_entities.detect { |s| s.site == current_site }

	  		@site_entities = [].tap do |s|
	  			
	    		relation.initialized_site_entities.each do |se|
	    			s << se if current_user.site_memberships.include?(se.site)
				end
			end
			
			@site_entity ||= begin
				_se = @site_entities.detect { |s| s.site == current_site }
				_se.force_dup = true
				_se
			end

			
	  	end
	  	
	  	def process_site_attrs(object_param = nil)
	  		
	  		object_param ||= controller_name.classify.constantize.name.titleize.gsub(' ', '_').downcase.to_sym
	  		
	  		process_attrs(object_param,params)

  		end
  	
	  	def process_attrs(key,value)
	  		
	  		nested_params = value[key] if value.is_a?(Hash) && value.has_key?(key)
	  		
	  		process_method_name = "process_#{key}_param".to_sym
	  		
	  		process_method_name = nil unless respond_to?(process_method_name,true)	
	  		
	  		nested_params.each do |k,v| 	
	  		    send(process_method_name,v,k) if process_method_name
	  		    
	  			process_attrs(k, nested_params)
	  		end if nested_params && nested_params.respond_to?(:each)
	  		
	  		send(process_method_name,value, key) if !nested_params && process_method_name
	  		
	  	end
	  	
	  	def process_city_attributes_param(value, key = nil)
	  		
	  	end
	  	
	  	def process_gallery_asset_entities_attributes_param(value, key = nil)
	  		
	  		value[:_destroy] = true if (value.has_key?(:enable) && value[:enable] != '1')
	  		
	  	
	  	end
	  	
	  	def process_asset_entities_attributes_param(value, key = nil)
	  		
	  		value[:_destroy] = true if (value.has_key?(:enable) && value[:enable] != '1') || (!value[:asset_attributes].nil? && value[:asset_attributes][:id].blank? && value[:asset_attributes][:source].blank?)
	  	end
	  	
	  	def process_site_entities_attributes_param(value, key = nil)
	  		value[:_destroy] = true if value[:enable] != '1'
	  	end
	  	
	  	def process_taxonomy_term_entities_attributes_param(value, key = nil)
	  	
	  		value[:_destroy] = true if (value.has_key?(:enable) && value[:enable] != '1') || (value[:taxonomy_term_id].blank? && !value.has_key?(:enable))
	  	
	  	end
	  	
	  	def process_similar_location_entities_attributes_param(value, key = nil)
	  	
	  		value[:_destroy] = true if (value.has_key?(:enable) && value[:enable] != '1')
	  	
	  	end
	  	
	  	def process_related_site_entities_attributes_param(value, key = nil)
	  	
	  		value[:_destroy] = true if (value.has_key?(:enable) && value[:enable] != '1')
	  	
	  	end
	end
end