class Role < ActiveRecord::Base
	has_many :users, :through => :memberships
	
	has_one :site, :through => :memberships
	has_many :memberships
	has_many :object_permissions, :as => :permissionable, :dependent => :delete_all
	#has_many :permissions
	has_many :permissions, :through => :object_permissions
	
	scope :has_members, proc {|membership| includes(:memberships).where("memberships.user_id IS NOT NULL")}
	
	
	attr_accessible :name, :label, :level, :object_permissions_attributes
	
	accepts_nested_attributes_for :object_permissions, allow_destroy: true
	
	ADMIN_ROLE_LEVEL = 2
	
	scope :admin_roles, proc { where(["level <= ?", ADMIN_ROLE_LEVEL])}
	
	
	def self.admin_role_level
		ADMIN_ROLE_LEVEL
	end
	
	def initialized_permissions # this is the key method
    [].tap do |o|
      Permission.all.each do |permission|
        if rp = object_permissions.find { |rp| rp.permission_id == permission.id }
          o << rp.tap { |rp| rp.enable ||= true }
        else
          o << ObjectPermission.new(permission: permission)
        end
      end
    end
  end
  
end
