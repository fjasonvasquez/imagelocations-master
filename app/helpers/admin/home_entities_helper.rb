module Admin::HomeEntitiesHelper
	def link_to_add_home_entity_fields(name, f, association)
		new_object = f.object.class.reflect_on_association(association).klass.new
		new_object.build_related_entity
		id = new_object.id
		fields = f.fields_for(association, new_object, :child_index => id) do |builder|
			render("admin/shared/" + association.to_s.singularize + "_fields", :f => builder)
		end
		
		#link_to_function(name, h("add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")"))
		link_to name, "#", :class => "add_#{association.to_s.singularize} btn disabled", 
							:data => {:id => id, :template => fields.gsub("/n",""),
							}
  end

end
