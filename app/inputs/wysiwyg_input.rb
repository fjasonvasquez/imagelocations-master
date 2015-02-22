class WysiwygInput < SimpleForm::Inputs::TextInput
  include ActionView::Helpers::FormTagHelper
  
  def input
  		
  		#ap sanitize_to_id @builder.object_name
  		template.render(:partial => 'fields/wysiwyg_field_tpl', 
  			:locals => { :builder => @builder, 
  			:attribute_name => attribute_name,
  			:input_id => sanitize_to_id(@builder.object_name),
  			:input_html_options => input_html_options} 
  		)    
  end
  #def sanitize_to_id(name)
  #        name.to_s.gsub(']','').gsub(/[^-a-zA-Z0-9:.]/, "_")
  #      end
end


