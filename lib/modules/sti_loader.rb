require 'active_support/concern'

module StiLoader
	module Model
		extend ActiveSupport::Concern
		  included do
				class << self
				def new_with_cast(*attributes, &block)
					if (h = attributes.first).is_a?(Hash) && !h.nil? && (type = h[:type] || h['type']) && type.length > 0 && (klass = type.constantize) != self
					  raise "wtF hax!!"  unless klass <= self
					  return klass.new(*attributes, &block)
					end
					
					new_without_cast(*attributes, &block)
				end
				alias_method_chain :new, :cast
			
			  end
		end
	end
	
	
	module Controller
		def get_klass
			klass =  params[:asset][:type] unless params[:asset].nil?
			klass ||= params[:type]
      		klass = klass.nil? ? Asset : klass.singularize.camelize.constantize
  			klass = Asset.subclasses.include?(klass) ? klass : Asset
  		end
	
	end

end