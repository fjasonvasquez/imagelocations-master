class AssetInput < SimpleForm::Inputs::TextInput
  include ActionView::Helpers::FormTagHelper
  
  attr_reader :asset_type
  
  def input
  	ap(options)
  		
  		asset_type = options[:asset_type].nil? ? "Asset" : options[:asset_type]
  		#ap sanitize_to_id @builder.object_name
  		template.render(:partial => 'fields/asset_field_tpl', 
  			:locals => {
  				:builder => @builder,
  				:asset_type => asset_type,
  				:attribute_name => attribute_name,
  				:input_id => sanitize_to_id(@builder.object_name),
  				:input_html_options => input_html_options
  			}
  		)    
  end

end


