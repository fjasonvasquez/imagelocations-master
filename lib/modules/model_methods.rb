require 'active_support/concern'

module ModelMethods
	extend ActiveSupport::Concern
		included do
			
			#scope :by_letter, lambda { |letter| where('name LIKE ?', letter+"%") unless letter.nil? }
			 
			class_eval do
				
				def self.labelize(value)
				
				
				
				
				end
				
				
			end
		end
	
	def labelize(value)
		value.classify.titleize
	end
	
	def nameize(value)
	
		value.parameterize.gsub("-","_")
	end
	
	def set_name_and_label
		
		self.name ||= self.label
		
		self.name = nameize(self.name)
		
		self.label ||= labelize(self.name)
	end
	
	module ClassMethods
	
	
		def labelize(value)
		
		
		end
	
	
	
	end

end

ActiveRecord::Base.send(:include, ModelMethods)