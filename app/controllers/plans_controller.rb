class PlansController < ApplicationController
	has_scope :site
	
	def index
		@plans = apply_scopes(Plan).saleable().order("plans.price asc")
		
		
		if user_signed_in?
			@plans.include_user(current_user)
		
		end
		
		@subscriptions = []
		
		_user_subscriptions = if user_signed_in? then apply_scopes(current_user.subscriptions).all else [] end
		
		@plans.each do |plan|
			
			
			
			_sub = current_user.subscriptions.find_by_plan_id(plan.id) if user_signed_in?
			
			_sub ||= plan.subscriptions.build(:user => current_user)
			
			
			
			@subscriptions << _sub
			
		end
		
		unless @plans.any?
			redirect_to root_path and return 
		end
		
		if @subscriptions.count == 1
			unless user_signed_in?
				store_location_for(:user, order_plan_path(@subscriptions.first.plan))
				redirect_to new_user_registration_path and return
			end
			redirect_to order_plan_path(@subscriptions.first.plan) and return
		end
		
	end
	
end