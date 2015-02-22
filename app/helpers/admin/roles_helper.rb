module Admin::RolesHelper
	def format_permission_label(permission)
		label_class = %w(label)
		case permission.action
			when :manage
				label_class << "label-inverse"
			when :update
				label_class << "label-warning"
			when :read
				label_class << "label-info"
			when :delete
				label_class << "label-important"
			when :create
				label_class << "label-success"
		end
		
		
			object = permission.object.is_a?(Symbol) ? nil : raw("&nbsp;") + content_tag(:strong, permission.object);
			action = content_tag(:span, permission.name, :class => label_class.join(' '))
			
			if object.nil?
				action
			else
				action + object
			end
	end
end
