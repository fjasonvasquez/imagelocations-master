class Admin::RolesController < Admin::AdminController

  before_filter :process_permissions_attrs, only: [:create, :update]
  
  respond_to :html, :xml, :json
  
  def index
    @roles = apply_scopes(Role).includes(:memberships).page(params[:page]).per(params[:per_page])
    respond_with @roles
  end

  def show
    @role = Role.find(params[:id])
  end
  
  def edit
    @role = Role.find(params[:id])
  end
  
  def update
    @role = Role.find(params[:id])
    if @role.update_attributes(params[:role])
      redirect_to admin_roles_path, :notice => "Role updated."
    else
      redirect_to admin_roless_path, :alert => "Unable to update role."
    end
  end
    
  def destroy
    role = Role.find(params[:id])
    unless role.memberships.count > 0
      role.destroy
      redirect_to admin_roles_path, :notice => "Role deleted."
    else
      redirect_to admin_roles_path, :notice => "There are users with this role."
    end
  end

  private 
  	 def process_permissions_attrs
	  	 params[:role][:object_permissions_attributes].values.each do |perm_attr|
		 	perm_attr[:_destroy] = true if perm_attr[:enable] != '1'
		 end
	end

end
