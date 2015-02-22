namespace :payment do
	desc "Payments"
	
	task :destroy  => [:environment] do
		Subscription.all.each do |s|
			s.destroy
		end
	
		Order.all.each do |o|
			o.destroy
		end
		
		
	end
	
	task :test  => [:environment] do
		
		user = User.find(10)
		
		user.subscriptions.each do |s|
			s.destroy
		end
		
		plan = Plan.find(1)
		
		subscription = plan.subscriptions.build(:user => user)
		
		subscription.build_checkout_order()
		
		cc_firstname = ""
		cc_lastname = ""
		cc_number = ""
		cc_month = ""		
		cc_year = ""
		
		
		
		payment = subscription.checkout_order.credit_card_payments.build(:cc_firstname => cc_firstname, :cc_lastname => cc_lastname, :cc_expire_month => cc_month, :cc_expire_year => cc_year, :cc_number => cc_number)
		

		subscription.save!
		
		ap subscription.checkout_order.paid
		
		subscription.reload
		
		ap subscription

		
		ap subscription.errors
		
		

	end
	
end