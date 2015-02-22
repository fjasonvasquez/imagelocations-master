class Order < ActiveRecord::Base
  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller && controller.current_user }
  
  attr_accessor :require_payment
  
  attr_accessible :order_date
  
  attr_accessible :billing_name
  attr_accessible :billing_address
  attr_accessible :billing_zip
  attr_accessible :billing_state
  attr_accessible :billing_country
  
  attr_accessible :total
  
  attr_accessible :notes
  
  attr_accessible :payments_attributes
  
  attr_accessible :credit_card_payments_attributes
  
  #validates :order_date, :presence => true
  #validates :billing_name, :presence => true
  #validates :billing_zip, :presence => true
  #validates :billing_state, :presence => true
  #validates :billing_country, :presence => true
  
  validate :paid?
  
  before_validation :check_payment_amounts
  
  before_validation :set_site
    
  before_create :set_order_date
  
  #after_create :activate_subscription
  
  #belongs_to :orderable, :polymorphic => true, :touch => true
  has_many :order_entities, :dependent => :destroy, :inverse_of => :order
  
  #has_one :subscription, :source => :orderable, :source_type => "Subscription"
  
  #has_many :subscriptions, :through => :order_entities, :source => :orderable, :source_type => 'Subscription'
  
  belongs_to :promo_code
  belongs_to :site
  
  
  has_one :subscription, :through => :order_entities, :source => :orderable, :source_type => "Subscription"
  
  has_one :user, :through => :subscription
  
  scope :site, -> site { where(:orders => {:site_id => site})}
  
  
  default_scope order("orders.order_date DESC")
  
  def set_site
  	site = Site.current
  end
  
  def check_payment_amounts
  	
  	
  	credit_card_payments.each do |cc|
  		
  		cc.amount = net_total() if cc.amount.zero?
  		
  	end
  
  end
  
  
  
  
  
  has_many :payments, :dependent => :destroy do
	  
  	def build(*args, &block)
    	#ap @association.owner
    	
    	#ap args
    	_payment = super(*args, &block)
    	
    	_payment.amount = @association.owner.net_total
		_payment
    end
  end
  
  
  has_many :credit_card_payments, :source => :payments, :source_type => 'CreditCardPayment' do
	  
  	def build(*args, &block)
    	#ap @association.owner
    	
    	#ap args
    	_payment = super(*args, &block)
    	
    	_payment.amount = @association.owner.net_total
		_payment
    end
  end
  accepts_nested_attributes_for :credit_card_payments, :allow_destroy => false
  accepts_nested_attributes_for :payments, :allow_destroy => false
  
  
  
# 
#   
#   
#   
#   
#   def activate_subscription
#   	
#   	subscriptions.find_each do |o|
#   		if o.class == Subscription and paid?
#   			o.activate
#   			o.save!
#   		end
#   	
#   	end
#   	
#   end
  
  def status
  	paid? ? "complete" : "pending"
  
  end
  
  def net_total
  	_total = total
  	
  	if promo_code
  		_total = promo_code.calculate(_total)
  	
  	end
  	_total
  end
  
  def paid?
  	
  	paid >= net_total
  end
  
  def paid
	  #payments.sum(:amount)
	  _p = 0.0
	  credit_card_payments.each do |cc|
	  	_p += cc.amount
	  	
	  end
	  _p
	  
  end
  
  def set_order_date
  	self.order_date ||= Time.now
  end
  
  
  
end
