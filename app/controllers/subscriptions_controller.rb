class SubscriptionsController < ApplicationController
	has_scope :site
	
	respond_to :html, :js, :json
	
	force_ssl :except => [:index, :public_promo_code], :unless => -> { Rails.env.development? }
	
	before_filter :authenticate_user!, :except => [:new, :checkout, :public_promo_code]
	
	def index
		@subscriptions = apply_scopes(current_user.subscriptions)
		
		redirect_to plans_path and return unless @subscriptions.any?
	
	end
	
	def new
		@plan = Plan.find(params[:id])
		
		unless user_signed_in?
			store_location_for(:user, order_plan_path(@plan))
			redirect_to new_user_registration_path and return
		end
		
		@subscription = @plan.subscriptions.build(:user => current_user)
		
		session[:plan] = @plan.id
		 
		redirect_to checkout_path and return
        #setup_checkout(@subscription)
        #render :action => 'checkout'
	end
	
	def public_promo_code
		
		if params.key? :id
		
			@promo_code = PromoCode.find(params[:id])
			
			unless @promo_code.nil? || !@promo_code.plan_saleable?
				session[:plan] = @promo_code.plan
				session[:promo_code] = @promo_code.id
			end
		else
			session[:plan] = nil
			session[:promo_code] = nil
		end
		respond_with @promo_code
		
				
	end
	
	def checkout
	    
	    unless user_signed_in?
			store_location_for(:user, checkout_path)
			redirect_to new_user_registration_path and return
		end
	    
		session[:plan] = Plan.saleable.first
		
		redirect_to root_path and return unless session[:plan]
		
		setup_checkout
		
	end
	
	def promo_code
		
		@promo_code = checkout_plan.promo_codes.find_by_active_code(params[:promo_code][:code])
		
		unless @promo_code.nil?
			session[:promo_code] = @promo_code.id
		end
		
		setup_checkout
		
		render(:action => "promo_code")
	end
	
	def remove_promo_code
		@promo_code = session[:promo_code] = nil
		
		setup_checkout
		
		render(:action => "promo_code")
	end
	
	def create

		setup_checkout(params[:subscription])

		return if @subscription.nil?

		_save_method = if @subscription.plan.free? then :save_without_order else :save_with_order end

		respond_to do |format|
		  if @subscription.respond_to?(_save_method) && @subscription.send(_save_method)
		  	
		  	SubscriptionMailer.subscription_email(@subscription).deliver
		  	SubscriptionMailer.subscription_notification_email(@subscription).deliver
		  	
		  	format.js {
			  	flash[:notice] = 'Subscription was successfully created.'
			  	flash.keep(:notice)
			  	render js: "window.location = '#{edit_user_registration_path(:protocol => "http")}'"
			  	#redirect_to ajax_redirect_to(subscriptions_path, 'Subscription was successfully created.') 
			}
		    format.html { redirect_to subscriptions_path, notice: 'Subscription was successfully created.' }
		  else
		  	
		  	format.js { render action: "checkout" }
		    format.html { render action: "checkout" }
		  end
		end

	
	end
	
	private
	def ajax_redirect_to(redirect_uri, notice = nil)
	    flash[:notice] = notice unless notice.nil?
        { js: "window.location.replace('#{redirect_uri}');" }
    end
	
	def set_processing(processing = true)
		session[:processing] = processing
	end
	
	def is_processing?
		!session[:processing].nil? && session[:processing]
	end
	
	
	def setup_checkout(attrs = {})
	
		@subscription ||= checkout_subscription(attrs)
				
		@promo_code = checkout_promo_code
		
		unless @promo_code.nil?
			@subscription.checkout_order.promo_code = @promo_code
		end
		
	end
	
	def checkout_subscription(attrs = {})
		_attrs = { :user => current_user }.merge(attrs)
		_subs = current_user.subscriptions.site(current_site).by_plan(checkout_plan)
		
		@subscription ||= begin
			
			if _subs.any? 
				_sub = _subs.first
				_sub.assign_attributes(attrs)
				
				if cannot?(:renew, _sub)
					redirect_to(edit_user_registration_path, :alert => 'Subscription cannot be renewed at this time.')
					_sub = nil
				end
				
				if !_sub.nil? && !checkout_plan.forever? && DateTime.now > _sub.expiration_date
				
					_sub.expiration_date = DateTime.now + checkout_plan.duration.days
					
				end
				
				_sub
			else
				_sub = checkout_plan.subscriptions.build(_attrs)
				if !checkout_plan.forever?
					_sub.expiration_date = DateTime.now + checkout_plan.duration.days
				end
				
				_sub
			end
		
		end
		
	end
	
	
	def checkout_promo_code
		begin
			checkout_plan.promo_codes.find_by_active_id(session[:promo_code]) unless session[:promo_code].nil?
		end
	end
	
	def checkout_plan
		begin
			Plan.site(current_site).saleable().find(session[:plan])
		end
	end
	

end
