class Admin::MembershipsController < Admin::AdminController

	def index
	
	end
	
	
	def show
	
	
	
	end
	
	def create
		@user = User.find(params[:user_id])
		@membership = Membership.new(params[:membership])
		@membership.user = @user
		@membership.save
	end
	def new
		#ap params
		@user = User.find(params[:user_id])
		#ap @user
		@membership = Membership.new
		@membership.user = @user
	
	end
end
