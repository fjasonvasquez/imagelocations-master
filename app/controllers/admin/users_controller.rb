class Admin::UsersController < Admin::AdminController

  has_scope :by_role
  has_scope :by_status
  has_scope :search
  
  has_scope :site
  
  before_filter :process_user_attrs, only: [:create, :update]  
 
  respond_to :html, :xml, :json
  
  def index
    @site_select = Site.active.has_members.all
    @users = apply_scopes(User).includes(:profile, :memberships, :sites, :roles).page(params[:page]).per(params[:per_page])
    respond_with @users
    #ap params
    
  end

  def show
    @user = User.find(params[:id])
  end
  
  def new
  
  	@user = User.new
  	@user.build_profile
  	@user.memberships.build(:site => current_site)
  	
  end

  def edit  
  	@user = User.find(params[:id])
  end
  
  def create
  	#if password is blank create one
  	if params[:user][:password].nil?
  		params[:user][:password] = Devise.friendly_token.first(User.password_length.first)
  		params[:user][:password_confirmation] = params[:user][:password]
    end
    @user = User.new(params[:user])
	
	respond_to do |format|
      if @user.save
        format.html { redirect_to admin_users_url, notice: 'User was successfully created.' }
        format.json { render json: @user, status: :created, location: admin_users_url }
      else
	  	#@user.build_profile
	  	#@user.memberships.build(:site => current_site)
      	
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def update
    
    @user = User.find(params[:id])
	
	respond_to do |format|
	    if @user.update_attributes(params[:user])
	      format.html { redirect_to admin_users_url, notice: 'User updated.' }
		  format.json { render json: @user, status: :created, location: admin_users_url }
	    else
	    	format.html { render action: "edit" }
	        format.json { render json: @user.errors, status: :unprocessable_entity }
	    end
	end
  end
    
  def destroy
    
    user = User.find(params[:id])
    unless user == current_user
      #user.profile.remove_avatar!
      user.destroy
      redirect_to admin_users_path, :notice => "User deleted."
    else
      redirect_to admin_users_path, :notice => "Can't delete yourself."
    end
  end
  
  #Allow admins to log in under another users account
  def sign_in_as
    #return unless current_user.is_an_admin?
    sign_in User.find(params[:id]), :bypass => true
    redirect_to root_url # or user_root_url
  end
  
  private 
  	 def process_user_attrs
  	 	 
  	 	 #Check if password was left blank
  	 	 
  	 	 if params[:user][:password].empty?
  	 	 	params[:user].delete(:password)
  	 	 	params[:user].delete(:password_confirmation)
  	 	 end unless params[:user][:password].nil?
  	 	 
  	 	
	  	 params[:user][:memberships_attributes].values.each do |perm_attr|
		 	perm_attr[:_destroy] = true if perm_attr[:enable] != '1'
		 end unless params[:user][:memberships_attributes].nil?
		
	end
end
