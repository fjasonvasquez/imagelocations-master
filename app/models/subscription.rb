class Subscription < ActiveRecord::Base
  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller && controller.current_user }
  
  RENEWABLE_WAITING_DAYS = 30
  
  attr_accessor :checkout_order, :checkout_order_attributes
  
  attr_accessible :start_date, :expiration_date, :status, :plan, :plan_id, :user, :orders, :checkout_order, :checkout_order_attributes
  
  attr_accessible :orders_attributes
  
  belongs_to :plan
  belongs_to :user
  
  has_one :site, :through => :plan
  
  has_many :order_entities, :as => :orderable, :dependent => :destroy, :autosave => true
  
  has_many :orders, :through => :order_entities
  
  before_create :set_start_date
  before_create :set_expiration_date
  before_create :set_status
  
  accepts_nested_attributes_for :orders, :allow_destroy => false
  
  scope :site, proc { |site| includes(:plan).where(:plans => {:site_id => site }) }
  
  SUBSCRIPTION_STATUSES = %w{active pending onhold expired}
  
  
  scope :by_status, proc { |status| where(:status => status) }
  
  scope :by_plan, proc { |plan| where(:plan_id => plan) }
  
  scope :active, -> { by_status(self.active_status) }
  
  validate :needs_order
  
  validate :validate_checkout_order
  
  delegate :name, :to => :plan
  
  #before_validation :set_checkout_order
  
  before_save :check_if_needs_activation
  
  def price
  	plan.price
  
  end
 
  
  def expiration_date2
  	_expiration_date = self[:expiration_date]
  	
  	set_expiration_date unless _expiration_date
  	
  	self[:expiration_date]  
  end
  
  
  def build_checkout_order()
  	self[:checkout_order] ||= begin 
  		_o = orders.build( :total => plan.price)  		
  		_o.site = site
  		_o
  		#_order = checkout_order_attributes.nil? ? orders.build : orders.build(checkout_order_attributes)
  		#_order.site = site
  		#_order.total = plan.price
  		#_order
  	end
  	
  	
  	
    self[:checkout_order]
  end
  
  def checkout_order
  	_co = self[:checkout_order]
  	
  	build_checkout_order if _co.nil?
  	
  	self[:checkout_order]
  	
  end
  
  def assign_attributes(new_attributes, options = {})

  	_return = super(new_attributes, options)
  	unless new_attributes["checkout_order_attributes"].nil?
  		checkout_order.assign_attributes(checkout_order_attributes)
  	end
  	_return
  end
  
  
  def set_start_date
  	self.start_date ||= Time.now
  
  end
  
  def set_expiration_date
  	unless plan.forever?
  		self.expiration_date ||= self.start_date + plan.duration.days
  	
  	end  
  end
  
  def set_status
  	self.status ||= self.class.active_status
  end
  
  def activate
  	self.status = self.class.active_status
  end
  
  def expire
  	self.status = self.class.expired_status
  end
  
  def check_if_needs_activation
  	  	
  	if expired_status = self.class.expired_status || new_record?
  	
  		if needs_payment? and checkout_order.paid?
  			activate
  		end
  
  	end
  	
  	
  	
  end
  
  def needs_payment?
  	!plan.free?
  end
  
  def renewable?
  	plan.renewable? && !self.expiration_date.nil? && (Time.now + RENEWABLE_WAITING_DAYS.days) >= self.expiration_date && !on_hold?
  end
  
  def started?
  	 Time.now >= self.start_date
  end
  
  def expired?
  	(!self.expiration_date.nil? && Time.now >= self.expiration_date)
  end
  
  def on_hold?
  	status == "onhold"
  end	
  
  def active?
  	 (status == self.class.active_status && !expired? && started?)
  end
  
  def current_status
  	if expired?
  		"expired"
  	else
  		status
  	end
  end
  
  def needs_order
  	if needs_payment? && !orders.any? && self[:checkout_order].nil?
  		errors.add(:orders, "Subscription requires payment")
  	end
  end
  
  def validate_checkout_order
  	checkout_order.valid?
  end
  
  def save_with_order

  
  
  	save
  end
  
  def save_without_order
  	self.status = self.class.active_status
  	save
  end
  
  def self.current_site
  	
  	site(Site.current)
  end
  def self.active_where
  	["subscriptions.status = ?",self.active_status]
  end
  
  def self.active_status
  	"active"
  end
  
  def self.expired_status
  	"expired"
  end
  
  def self.to_hash
  	all.to_a.map(&:serializable_hash)
  end
end
