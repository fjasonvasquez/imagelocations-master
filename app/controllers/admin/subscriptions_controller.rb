class Admin::SubscriptionsController < Admin::AdminController
	has_scope :site
	respond_to :html, :xml, :json
	
	def index
		@subscriptions = apply_scopes(Subscription).page(params[:page]).per(params[:per_page])
		respond_with @subscriptions
	end
	
	def edit
		@subscription = apply_scopes(Subscription).find(params[:id])
		respond_with @subscription
	end
	
	def show
		@subscription = apply_scopes(Subscription).find(params[:id])
		respond_with @subscription
	end
	
	def create
		@user = User.find(params[:user_id])
		@subscription = Subscription.new(params[:subscription])
		@subscription.user = @user
		
		respond_to do |format|
		  if @subscription.save
		    format.html { redirect_to admin_user_url(@user), notice: 'Subscription was successfully created.' }
		    format.json { render json: @plan, status: :created, plan: admin_plans_url }
		  else
		    format.html { render action: "new" }
		    format.json { render json: @plan.errors, status: :unprocessable_entity }
		  end
		end
	end
	
	def update
	    @subscription = Subscription.find(params[:id])
    
    
	    respond_to do |format|
	      if @subscription.update_attributes(params[:subscription])
	        format.html { redirect_to :back, notice: 'Subscription was successfully updated.' }
	        format.json { head :no_content }
	      else
	        
	        format.html { render action: "edit" }
	        format.json { render json: @subscription.errors, status: :unprocessable_entity }
	      end
	    end
  	end

	def destroy
	    @subscription = Subscription.find(params[:id])
	    @subscription.destroy
	
	    respond_to do |format|
	      format.html { redirect_to admin_subscriptions_url() }
	      format.json { head :no_content }
	    end
	end
	
	def new
		@user = User.find(params[:user_id])
		@subscription = Subscription.new
		@subscription.user = @user
	
	end


end
