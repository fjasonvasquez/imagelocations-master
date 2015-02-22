class TopCategory < Category
	
	def self.category_where
  		"categories.type = 'TopCategory'"
	end
	    
    def is_special?
  		true
  	end
end
