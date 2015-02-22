class Permission < ActiveRecord::Base
  attr_accessible :name, :action, :object
  
  has_many :object_permissions, :dependent => :delete_all
  has_many :roles, :through => :object_permissions, :source_type => "Role", :inverse_of => :permission
  
  
  scope :by_action, proc {|action| where(:action => action.underscore)}
  scope :by_object, proc {|object| where(:object => object.camelize)}
  
  #has_one :role_permission, :through => :roles
 
  
  def action
  	return self[:action].to_sym
  
  end
  
  def object
  	if self[:object] == "all"
  		return :all
  	else
  		return self[:object].constantize
  	end
  end
  
  def object_to_sym
  	self[:object].to_sym
  
  end
  
end
