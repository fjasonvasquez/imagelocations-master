class User < ActiveRecord::Base
  
  #scopes for filtering
  scope :by_site, proc { |site| includes(:memberships).where(:memberships => {:site_id => [0,site] }) }
  scope :by_role, proc { |role| includes(:memberships).where(:memberships => {:role_id => role }) }
  scope :by_status, proc { |status| where(:status => status) }
  
  scope :site, proc { |site| includes(:memberships).where("memberships.site_id IN (0,?) OR ? = 0", site, site.to_i) }
  
  has_one :profile, :inverse_of => :user, :dependent => :destroy
  
  has_many :authentications, :dependent => :delete_all
  
  has_many :memberships, :dependent => :delete_all
  has_many :roles, :through => :memberships
  has_many :sites, :through => :memberships
  has_many :role_permissions, :through => :roles, :source => :object_permissions
  has_many :permissions, :through => :role_permissions 
  
  has_many :current_site_memberships, :conditions => proc { ["memberships.site_id IN(?)",[0,Site.current.id]]}, :class_name => "Membership"
  
  has_many :admin_memberships, :include => :role, :conditions => ["roles.level >= ?",Role.admin_role_level], :class_name => "Membership"
  
  has_many :current_site_admin_memberships, :include => :role, :conditions => proc { ["memberships.site_id IN(?) AND roles.level <= ?",[0,Site.current.id],Role.admin_role_level]}, :class_name => "Membership"
  
  has_many :current_site_roles, :through => :current_site_memberships,  :source => :role
  
  
  def site_role_permissions(site_id, is_admin)
	  m_table = Membership.arel_table
	  
	  r_table = Role.arel_table
	  
	  rp_table = ObjectPermission.arel_table
	  
	  cond = rp_table[:permissionable_id].eq(r_table[:id]).and(rp_table[:permissionable_type].eq("Role"))
	  
	  if is_admin
		 cond = cond.and(r_table[:level].lteq(Role.admin_role_level)) 
	  end
	  
	  r_join = rp_table.join(r_table, Arel::Nodes::InnerJoin)
	  	.on(cond)
	  .join(m_table,Arel::Nodes::InnerJoin)
	  	.on(r_table[:id].eq(m_table[:role_id]).and(m_table[:user_id].eq(id))
	  )
	  
	  ObjectPermission.select("object_permissions.*, memberships.site_id AS permission_site_id").includes(:permission).joins(r_join.join_sources).where(m_table[:site_id].in([0,site_id])).group(:permission_id)
  end

		  	 				
		  	 				
		  	 				
  
  has_many :current_site_role_permissions, :through => :current_site_roles,  :source => :object_permissions
  has_many :current_site_permissions, :through => :current_site_role_permissions,  :source => :permission
  
  
  has_many :site_memberships, 
  		   :class_name => "Site", 
  		   :finder_sql => proc {"SELECT sites.*,memberships.role_id FROM sites LEFT JOIN memberships ON sites.id = memberships.site_id OR memberships.site_id = 0 WHERE memberships.user_id = #{id}"}    	
  
  has_many :admin_site_memberships, 
  		   :class_name => "Site", 
  		   :finder_sql => proc {"SELECT sites.*,memberships.role_id FROM sites LEFT JOIN memberships ON sites.id = memberships.site_id OR memberships.site_id = 0 INNER JOIN roles ON memberships.role_id = roles.id AND roles.level <= #{Role.admin_role_level} WHERE memberships.user_id = #{id}"}  
  
  
  has_many :subscriptions
  
  has_many :active_subscriptions, :class_name => "Subscription", :conditions => proc { Subscription.active_where }
  
  has_many :active_plans, :through => :active_subscriptions, :source => :plan, :conditions => proc { Plan.active_where }
  
  has_many :active_subscription_permissions, :through => :active_plans, :source => :object_permissions
  
  
  has_many :plans, :through => :subscriptions
  
  has_many :subscription_permissions, :through => :plans, :source => :object_permissions
  
  has_many :session_activations, dependent: :destroy
  
  
  #has_many :active_subscription_permissions, :through => :plans, :source => :object_permissions
  
  accepts_nested_attributes_for :profile
  accepts_nested_attributes_for :memberships, :allow_destroy => true
  #has_many :site_roles, :through => :memberships, :through => :memberships
  #		   :class_name => 'Site',
  #		   :source => :site,
  #		   :conditions => "sites.id = 0" do
  #	  		   def <<(developer)
  #		  		   ap developer
  #		  		   #proxy_owner.project_users.create(:role => 'developer', :user => developer)
  #		  	   end
  #		   end
  
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
 
  devise :omniauthable, :omniauth_providers => [:google_oauth2]
  
  attr_accessor :login
  # Setup accessible (or protected) attributes for your model
  attr_accessible :username, :email, 
  				  :password, :password_confirmation, :remember_me, 
  				  :memberships, :roles, :permissions, :status
  
  attr_accessible :login
  
  attr_accessible :profile, :profile_attributes, :memberships_attributes
  
  attr_accessible :plan_ids
  
  before_create :set_default_membership
  before_create :create_profile
  
  before_validation :format_username
  
  validates_format_of :username, :with => /^[A-Za-z\d_]+$/
  
  validates_associated :roles
  
  validates_presence_of :profile
  
  delegate :avatar, :first_name, :last_name, :to => :profile
  
  #List of user status levels
  USER_STATUSES = %w{active inactive banned}
  
  validates :status, :inclusion => { :in => USER_STATUSES }
  
  
  before_save { build_profile unless profile }
  
  
  def activate_session
    session_activations.activate(SecureRandom.hex).session_id
  end

  def exclusive_session(id)
    session_activations.exclusive(id)
  end

  def session_active?(id)
    session_activations.active? id
  end
  
  
  def full_name
  	"#{self.first_name} #{self.last_name}"
  end
  
  def active_for_authentication?
  	super && is_active?
  end
  
  def has_authentication_provider?(provider)
  	
  	_auth = authentications.find_by_provider(provider)
  	
  	!_auth.nil?
  end
  
  #def status
  #	self[:status].to_sym
  #end
  
  
  def is_active?
  	self.status.to_sym == :active
  end
  
  def is_subscribed?
  	active_subscriptions.site(Site.current.id).any?
  end
  
  
  def self.deactivated_status
  	return 'inactive'
  end
  
  
  def self.search(string)
  	condition = ["%" + string.downcase + "%"]
  	includes(:profile).where("LOWER(username) LIKE ? OR LOWER(email) LIKE ? OR LOWER(profiles.first_name || ' ' || profiles.last_name) LIKE ?",condition,condition,condition)
  end
  
  private
  	#Allow login via username or email
  	def self.find_first_by_auth_conditions(warden_conditions)
      conditions = warden_conditions.dup
      if login = conditions.delete(:login)
        where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
      else
        where(conditions).first
      end
    end
    
    #format email to a username is none is given
    def format_username
    	_email_base = self.email[/[^@]+/]
    	self.username ||= _email_base.camelize.underscore.gsub(/\./,"_") unless _email_base.nil?

    end
    
    def create_profile
    	self.profile ||= build_profile
    
    end
	  #If a user is being created without a membership, add the default
	  def set_default_membership
	  	if self.sites.empty? && self.roles.empty? && self.memberships.empty?
	  		self.memberships.build(:site => Site.current,:role => Role.find_by_name('registered'))
	  	end
	  	#!self.sites.empty? || self.sites << Site.first
	  end
  
end
