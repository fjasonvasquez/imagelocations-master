module PlansHelper
	def format_price(price)
		if price.zero?
			"Free"
		else
			number_to_currency(price)
		end
	end
	
	def format_duration(duration)
		duration
	end
end
