def require_sti_models 
	%w[taxonomy tag_taxonomy select_taxonomy boolean_taxonomy keyword_taxonomy].each do |c|
	    	require_dependency File.join("app","models","taxonomy","#{c}.rb")
    	end
    
    %w[asset image video].each do |c|
    	require_dependency File.join("app","models","asset","#{c}.rb")
    end
    
	Dir[File.dirname(__FILE__) + '/../../app/models/banner_entities/*.rb'].each do |file|	
		require_dependency file 
	end
	
	Dir[File.dirname(__FILE__) + '/../../app/models/region_conditions/*.rb'].each do |file|	
		require_dependency file 
	end
	
	Dir[File.dirname(__FILE__) + '/../../app/models/categories/*.rb'].each do |file|	
		require_dependency file 
	end
	
	Dir[File.dirname(__FILE__) + '/../../app/models/payment/*.rb'].each do |file|	
		require_dependency file 
	end
	
end


if Rails.env.development?
  require_sti_models
end

if Rails.env.development?
	ActionDispatch::Callbacks.before do    	
    	require_sti_models
	end
	
end
