class Site < ActiveRecord::Base
  include GlobalFunctions
  
  attr_accessor :default, :subdomain
  attr_accessible :id, :active, :namespace, :name, :hostname, :google_tracking_id
  attr_accessible :sections_attributes, :settings_attributes, :asset_sizes_attributes, :default, :subdomain
  
  has_many :settings, :dependent => :delete_all
  
  has_many :site_entities, :inverse_of => :site, :dependent => :destroy
  has_many :locations, :through => :site_entities, :source => :site_entitable, :source_type => 'Location'
  has_many :plans, :inverse_of => :site, :dependent => :destroy
  
  has_many :subscriptions, :through => :plans
  
  has_many :orders, :through => :subscriptions, :dependent => :destroy
  
  has_many :regions, :through => :site_entities, :source => :site_entitable, :source_type => 'Region', :order => "site_entities.priority ASC" do
  
  	def current(id = nil)
  		unless id.nil?
  			find(id)
  			
  		else
  			first()
  		
  		end
  	
  	end
  end
  
  has_many :sections, :dependent => :destroy
  
  has_many :cities, :through => :locations, :uniq => true
  
  has_many :asset_sizes,  :dependent => :destroy
  
  has_many :fields, :dependent => :destroy
  
  has_many :memberships
  has_many :users, :through => :memberships
  
  has_many :location_applications
  
  scope :active, proc { |active| where(:active => TRUE)}
  scope :not_default, proc { where("sites.id != 0")}
  scope :has_members, proc {|membership| includes(:memberships).where("memberships.user_id IS NOT NULL")}
  scope :excluding_ids, lambda { |ids| where(['id NOT IN (?)', ids]) if ids.any? }
  
  accepts_nested_attributes_for :settings, allow_destroy: true
  accepts_nested_attributes_for :asset_sizes, allow_destroy: true
  
  accepts_nested_attributes_for :sections, allow_destroy: true
  
  #default_scope includes(:settings)
  
  def namespace
    super.try :to_sym
  end

  def namespace=(value)
    super(value.to_sym)
    namespace
  end
  
  def setting_value(key)
  	s = settings.find_by_key(key)
  	
  	s.value unless s.nil?
  end
  
  def setting?(key)
  	!settings.find_by_key(key).nil?
  end
  
  def default?
  	return self.id == 0
  
  end
  
  def host
  	unless subdomain.nil?
  		"#{subdomain}.#{hostname}"
  	else
  		hostname
  	end
  end
  
  def self.by_hostname(host)
  	
  	find(:first, :conditions => ["hostname = ? AND active = 1 AND id != 0",host])
  end
  
  def self.default
  	find(:first, :conditions => {:id => 0})
  	#new({:id => 0, :name => 'Default', :default => true})
  end
  
  def self.first_non_default
  	#find(:first, :conditions => ["namespace != 0"])
  
  	find_by_namespace(Rails.configuration.default_site_namespace)
  end
  
  def self.current
  	Thread.current[:site] || self.default
  end
  
  def self.current=(site)
    raise(ArgumentError,
        "Invalid site. Expected an object of class 'Site', got #{site.inspect}") unless site.is_a?(Site)
    Thread.current[:site] = site
  end
  
end
