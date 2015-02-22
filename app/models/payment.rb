class Payment < ActiveRecord::Base
  attr_accessible :amount, :token, :status, :meta
  belongs_to :order
  
  serialize :meta, Hash
  
  
  validate :amount_is_not_zero
  
  
  def amount_is_not_zero
  	
  
  	errors.add(:amount, "Payment amount must be more than zero.") if amount.zero?
  end
  
  
  def payment_type
  	self.class.name.gsub("Payment","").underscore.gsub("_"," ").capitalize
  
  end
  
end
