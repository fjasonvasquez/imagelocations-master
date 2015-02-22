class CreditCardPayment < Payment

	attr_accessor :cc_number, :cc_expire_month, :cc_expire_year, :cc_firstname, :cc_lastname, :cc_security_code
  
	attr_accessible :cc_number, :cc_expire_month, :cc_expire_year, :cc_firstname, :cc_lastname, :cc_security_code
	validates_presence_of :cc_number, :cc_expire_month, :cc_expire_year, :cc_firstname, :cc_lastname
	
	validate :valid_credit_card
	
	validate :authorize_payment
	#after_create :capture_payment
	
	#validate :capture_payment
	
	def authorize_payment
		if self.token.nil? and credit_card.valid?
			r = gateway.sale(amount, credit_card)
			
			self.meta = r.result
			
			if r.successful?
				self.token = r.authorization_token
			end
			
			errors.add(:payment, "Payment could not be processed") unless r.successful?
		end
	end
	
	
	def capture_payment
		r = gateway.capture(amount, token, {:orderid => order.id})
		
		self.meta = r.result
	end
	
	def credit_card
		@credit_card ||= Payflow::CreditCard.new({ :number => cc_number, :month => cc_expire_month, :year => cc_expire_year, :first_name => cc_firstname, :last_name => cc_lastname , :security_code => cc_security_code})
	end
	
	def valid_credit_card
		
		if !credit_card.valid?
			credit_card.errors.each do |attribute, error|
				
				if attribute == :number
					errors.add(:cc_number, error)
				end
			end	
		
		end
	end
	
	def gateway
		
		@gateway ||= Payflow::Gateway.new(
			OpenStruct.new(
				login: Rails.configuration.payflow[:login], 
				password: Rails.configuration.payflow[:password], 
				partner: Rails.configuration.payflow[:partner]), 
				{	
					:test => Rails.configuration.payflow[:test], 
					:mock => Rails.configuration.payflow[:mock], 
					:user => Rails.configuration.payflow[:user]
				}
			)
	end

end