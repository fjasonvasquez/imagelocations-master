class PromoCode < ActiveRecord::Base
  attr_accessible :code, :plan, :discount, :plan_id, :status
  
  belongs_to :plan
  
  validates_presence_of :code, :discount, :status, :plan
  
  validates_associated :plan
  
  
  PROMO_CODE_STATUSES = %w{active inactive}
  
  validates :status, :inclusion => PROMO_CODE_STATUSES
  
  validates :code, :length => { :minimum => 2 }
  
  validates :discount, :numericality => { :greater_than => 0}
  
  scope :active, ->  { where(:promo_codes => {:status => self.active_status }) }
  
  scope :site, -> site { joins(:plan).where(:plans => {:site_id => site }) }
  
  scope :by_plan, -> plan { where(:promo_codes => {:plan_id => plan }) }
  
  
  delegate :saleable?, :to => :plan, :prefix => true, :allow_nil => true
  
  def self.active_where
  	["promo_codes.status = ?",self.active_status]
  end
  
  def self.active_status
  	"active"
  end
  
  
  def self.find_by_active_code(code)
  	site(Site.current.id).active().find_by_code(code)
  end
  
  def self.find_by_active_id(id)
  	site(Site.current.id).active().find_by_id(id)
  end
  
  def discounted_price
	 plan.price - discount
	  
  end
  
  def calculate(total)
  	
  	total - discount
  end
  
end
