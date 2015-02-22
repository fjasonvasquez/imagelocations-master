module SubscriptionsHelper
	
	def format_subscription_date(date, date_format = '%B %e at %l:%M %p')
		if date.nil?
			"Forever"
		else
			date.strftime(date_format)
		end	
	end
	
	def format_order_date(date)
		unless date.nil? then date.to_date else "Never" end
	
	end	
	
	def format_expiration_date(date, date_format = '%B %e at %l:%M %p %Y')
		if date.nil?
			"Forever"
		else
			date.strftime(date_format)
		end	
		
	end
	
	def format_subscription_status(subscription)
	
		case subscription.current_status
		
			when "active"
				"Active until #{format_expiration_date(subscription.expiration_date)}"
			
			when "expired"
		end
			
			
		
	end
	

end
