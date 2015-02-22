class ObjectPermission < ActiveRecord::Base
	belongs_to :permissionable, :polymorphic => true
	
	belongs_to :permission, :inverse_of => :object_permissions, :touch => true
	
	has_one :site, :through => :permissionable
	
	attr_accessor :enable, :permission_site_id
	attr_accessible :role, :permission, :role_id, :permission_id, :conditions, :site, :enable
	
	
	serialize :conditions, Hash
	
	delegate :object, :to => :permission, :allow_nil => false
	delegate :action, :to => :permission, :allow_nil => false
		
	before_create :set_default_conditions
	
	validates_presence_of :permission
	#validates_presence_of :conditions
	
	CONDITIONS = []
	
	
	
	
	private
  	
  	def set_default_conditions
  		
  		self.conditions.is_a?(Hash) || self.conditions = {}

  	end
  	

end
