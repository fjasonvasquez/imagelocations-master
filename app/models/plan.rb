class Plan < ActiveRecord::Base
  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller && controller.current_user }

  attr_accessible :name, :site, :duration, :price, :renewable, :saleable, :description, :status
  
  attr_accessible :object_permissions_attributes
  attr_accessor :action, :current_promo_code
  
  belongs_to :site
  before_create :set_site
  
  has_many :subscriptions,  :dependent => :destroy
  
  has_many :promo_codes
  
  has_many :users, :through => :subscriptions
  
  has_many :object_permissions, :as => :permissionable, :dependent => :delete_all
  
  accepts_nested_attributes_for :object_permissions, allow_destroy: true
  
  scope :site, -> site { where({:site_id => site }) }
  
  
  scope :active, ->  { where({:status => self.active_status }) }
  
  scope :saleable, -> { where(:saleable => true).active() }
  
  PLAN_STATUSES = %w{active inactive}
  
  def calculated_price
	  
	_price = price
	
	unless  current_promo_code.nil?
		_price = current_promo_code.calculate(_price)
	end
	_price
  end
  
  def set_site
  	self.site ||= Site.current
  end
  
  def forever?
  	duration.zero?
  end
  
  def free?
  	price.zero?
  end
  
  def active?
  	status == self.class.active_status
  end
  
  def self.active_where
  	["plans.status = ?",self.active_status]
  end
  
  def self.active_status
  	"active"
  end
  
  def self.include_user(user)
  	#joins(["LEFT JOIN subscriptions ON subscriptions.user_id = ?", user.id])
  	includes(:subscriptions => [:user])
  	.select("subscriptions.user_id IS NOT NULL AS user_subscription, plan.*")
  	.where("subscriptions.user_id = ? OR subscriptions.user_id = NULL", user.id)
  end
  
  def initialized_permissions
    [].tap do |o|
      Permission.all.each do |permission|
        if pp = object_permissions.find { |pp| pp.permission_id == permission.id }
          o << pp.tap { |pp| pp.enable ||= true }
        else
          o << ObjectPermission.new(permission: permission)
        end
      end
	end
  end
end
