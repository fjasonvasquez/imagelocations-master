namespace :permissions do
	desc "Populates db with permissions from controllers"
	task :setup => :environment do
		
		found, added = setup_actions_controllers_db
		puts "Found #{found} permissions, #{added} new added."
	end

	def eval_cancan_action(action)
	  case action.to_s
		  when "index", "show", "search"
		    cancan_action = :read
		    action_desc = I18n.t :read
		  when "create", "new"
		    cancan_action = :create
		    action_desc = I18n.t :create
		  when "edit", "update"
		    cancan_action = :update
		    action_desc = I18n.t :edit
		  when "delete", "destroy"
		    cancan_action = :delete
		    action_desc = I18n.t :delete
	  else
	  	
	    cancan_action = action.to_sym
	    action_desc = "Other: " << action
	    
	  end
	  return action_desc, cancan_action
	end
    
  def write_permission(model, cancan_action, name, force_id_1 = false)
	  permission = Permission.find(:first, :conditions => ["object = ? and action = ?", model, cancan_action])
	  @permission_count += 1
	  if not permission
	    permission = Permission.new
	    permission.id = 1 unless not force_id_1
	    permission.object =  model
	    permission.action = cancan_action
	    permission.name = name
	    permission.save
	    @permission_added += 1
	  else
	    permission.name = name
	    permission.save
	  end
  end
  
  #Find all controllers and constantize
  def constantize_dir_files(dir)
  	
  	 rbfiles = File.join(dir, "**", "*.rb")  	 
  	 controllers = Dir.glob(rbfiles) do |controller|
  	 	if controller =~ /_controller/
  	 		class_name = controller.gsub("#{dir}/","").gsub(".rb","").camelize.constantize.new
  	 	end
  	 end
  end
  
  def get_class_subclasses(parent)
  	class_list = []
  	
  	if !parent.subclasses.empty?
  		parent.subclasses.each do |child|
  			class_list += get_class_subclasses child
  		end
  	end 	
  	
  	class_list << parent
  	return class_list
  end
  
  
 def valid_action(action)
 	
 	action.to_s.index("_callback").nil? && action.to_s.index("store_controller_for_public_activity").nil? && action =~ /^([A-Za-z\d*]+)+([\w]*)+([A-Za-z\d*]+)$/
 
 end
  
  def setup_actions_controllers_db
	  @permission_count = 0
	  @permission_added = 0
  	  #Add a super permission for admin roles
	  write_permission("all", "manage", "Everything", true)
	  
	  #Recursively constantize all controllers
	  constantize_dir_files("#{Rails.root}/app/controllers")
	  
	  controllers = get_class_subclasses(ApplicationController)
	  
	  #Iterate through controllers to get actions
	  controllers.each do |controller|
	  	
	    if controller.respond_to?(:permission) && controller.permission
	      
	      clazz = controller.permission
	      write_permission(controller.permission, :manage, I18n.t(:manage))
	      controller.action_methods.each do |action| 
	        if valid_action(action)
	          action_name, cancan_action = eval_cancan_action(action)
	          write_permission(clazz, cancan_action, action_name)
	        end
	      end
	    end
	  end
	  
	  return @permission_count, @permission_added
	end
end