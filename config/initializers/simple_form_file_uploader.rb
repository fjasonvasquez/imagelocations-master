SimpleForm.setup do |config|
  config.wrappers :file, :tag => 'div', :class => 'control-group', :error_class => 'error' do |b|
	  b.use :html5
	  b.use :placeholder
	  b.use :label
	  b.wrapper :tag => 'div', :class => 'controls' do |ba|
	    ba.wrapper :tag => 'span', :class => 'btn btn-success fileinput-button' do |span|
	      span.wrapper :tag => :i, :class => "icon-plus icon-white" do |i|
	      end
	      span.wrapper :tag => :span, :content => "Add Files.." do |t|
	      end
	      span.use :input
	    end
	    ba.use :error, :wrap_with => { :tag => 'span', :class => 'help-inline' }
	    ba.use :hint,  :wrap_with => { :tag => 'p', :class => 'help-block' }
	  end
	  b.use :upload_template
	  b.use :download_template
	  #b.wrapper :tag => 'script', :class => 'template' do |s|
	  #	s.use :upload_template
	  #end
   end
end