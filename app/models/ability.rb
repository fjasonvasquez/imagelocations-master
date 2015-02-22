class Ability
  include CanCan::Ability

  def initialize(user, site, is_admin)
  	@user, @site = user, site
  	
  	#ap user.current_site_roles.admin_roles
  	
  	#abort

  	#_role_permissions = user.current_site_role_permissions.group(:permission_id).includes(:permission)
  	
  	_permissions = user.site_role_permissions(site.id,is_admin)
  	
  	_user_sites = _permissions.map {|rp| rp.attributes['permission_site_id']}.uniq


  	unless is_admin
		_subscription_permissions = user.active_subscription_permissions.where("plans.site_id = ? OR plans.site_id = 0",site[:id]).group(:permission_id).includes(:permission)
  		_permissions = _permissions + _subscription_permissions
  	end
  
  
  	#ap user.roles
  	#user.permissions.include(
  	_permissions.each do |permission|
  		
  		if permission.object == Site &&  !permission.attributes['permission_site_id'].zero?
	  		can permission.action, permission.object, { :id => _user_sites }
	  	else
	  		can permission.action, permission.object, permission.conditions
	  	end
  		#can permission.action
  		#if(permission.can)
  		#	can permission.action, permission.object.camelize.constantize, permission.conditions
  		#else 
  		#	cannot permission.action, permission.object.camelize.constantize, permission.conditions
  		#end
  	end
  	
  	can :order, Plan do |plan|
  		#ap user.plan_ids.include?(plan.id)
  		!user.plan_ids.include?(plan.id) && plan.saleable? && plan.active?
  		
  	end
  	
  	can :renew, Plan do |plan|
  		_subscription = user.subscriptions.find_by_plan_id(plan.id)
  		user.plan_ids.include?(plan.id) && plan.saleable? && plan.active? && _subscription.renewable?
  	end
  	
  	
  	can :renew, Subscription do |subscription|
  		#ap subscription.renewable?
  		subscription.user == user && subscription.plan.saleable? && subscription.plan.active? && subscription.renewable?
  	end
  	
    #can :manage, :all
  	#@permissions = @user.role.permissions.where(:site_id => @site.id)
  	
  	#Rails.logger.debug(@permissions.inspect)
  	#Rails.logger.debug(user.role.permissions)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user 
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. 
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
