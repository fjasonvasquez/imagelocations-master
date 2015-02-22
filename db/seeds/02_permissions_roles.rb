
default_roles = [{
		:name => :admin,
		:level => 0,
		:permissions => Permission.find(1)
	}, {
		:name => :manager,
		:level => 1,
		:permissions => Permission.by_action("manage")
	}, {
		:name => :employee,
		:level => 2,
		:permissions => Permission.by_action("read")
	},{
		:name => :member,
		:level => 3,
		:permissions => Permission.by_action("read")
	},{
		:name => :registered,
		:level => 4,
		:permissions => Permission.by_action("read")
	}
]

default_roles.each do |role|
  @role = Role.find_or_create_by_name role[:name]
  @role.label = role[:name].capitalize
  @role.level = role[:level]
  if role[:permissions].is_a?(Array)
  	 @role.permissions = role[:permissions]
  
  else
  	 @role.permissions << role[:permissions]
  end
 
  @role.save
end


$ROLES = default_roles