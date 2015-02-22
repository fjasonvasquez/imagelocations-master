require 'filtering'

#Yah....This is hacky
if Rails.env.development?
	ActionDispatch::Callbacks.before do
		ActiveRecord::Base.send(:include, Filtering::Model)
		Admin::AdminHelper.send(:include, Filtering::Helper)
		Admin::AdminController.send(:include, Filtering::Controller)
	end
	
end