class FileUploaderInput < SimpleForm::Inputs::FileInput
  
  def input
    template.content_tag(:div, 
  		template.render(:partial => 'fields/file_uploader_field_tpl', 
  			:locals => { :builder => @builder, 
  			:attribute_name => attribute_name, 
  			:input_html_options => input_html_options} 
  		),
  		:id => "#{attribute_name}-uploader-field",
  		:class => "file-uploader-field",
  		'data-file-attribute' => attribute_name,
  		'data-upload-template' => "#{attribute_name}-upload-template",
  		'data-download-template' => "#{attribute_name}-download-template") + upload_template + download_template
    
  end
  
  def upload_template
  	template.content_tag(:script, 
  		template.render(:partial => 'fields/file_uploader_upload_tpl'), 
  		:type => 'text/x-tmpl',
  		:id => "#{attribute_name}-upload-template")
  end
  
  def download_template
  	template.content_tag(:script, 
  		template.render(:partial => 'fields/file_uploader_download_tpl'), 
  		:type => 'text/x-tmpl',
  		:id => "#{attribute_name}-download-template")
  	
  end
end