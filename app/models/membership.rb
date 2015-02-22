class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :site
  belongs_to :role
  
  has_many :permissions, :through => :role
  
  #scope :site, proc { |site| where(:site => site) }
  
  attr_accessor :enable
  
  after_initialize :set_default_role
  
  attr_accessible :user, :site, :role, :user_id, :site_id, :role_id, :enable
  
  before_create :set_default_site
  
  after_initialize do
  	set_all_sites FALSE 
  
  
  end
  
  def set_all_sites(all = TRUE)
  	@@all_sites = all
  end
  
  
  def set_default_role
  	self.role ||= Role.order("level DESC").limit(1).first
  end
  
  def set_default_site
  	
  	unless @@all_sites
  		self.site ||= Site.first
  	end
  end
  
  def site_with_site_finder
  	
  	s = self.site_without_site_finder
  	return s
  end
  
  alias_method_chain :site, :site_finder
  

end
