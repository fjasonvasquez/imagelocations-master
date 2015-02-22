module Admin::SettingsHelper
	def format_setting_options(s)
		options = s.options
		options[:input_html] = Hash.new
		options[:input_html][:class] = "input-block-level"
		options
	end
	
	
	
end
