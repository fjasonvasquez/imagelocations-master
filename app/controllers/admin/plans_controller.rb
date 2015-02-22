class Admin::PlansController < Admin::AdminController
	
	has_scope :site
	respond_to :html, :xml, :json
	
	before_filter :process_permissions_attrs, only: [:create, :update]
	
	
	def index
  		@plans = apply_scopes(Plan).page(params[:page]).per(params[:per_page])
  		respond_with @plans
	end
	def new
    	@plan = Plan.new    
	end
	
	def show
		@plan = Plan.find(params[:id])
	end
	
	def edit
		@plan = Plan.find(params[:id])
	end
	
	def create
		@plan = Plan.new(params[:plan])
	
		respond_to do |format|
		  if @plan.save
		    format.html { redirect_to admin_plans_url, notice: 'Plan was successfully created.' }
		    format.json { render json: @plan, status: :created, plan: admin_plans_url }
		  else
		    format.html { render action: "new" }
		    format.json { render json: @plan.errors, status: :unprocessable_entity }
		  end
		end
	end
	
	def update
		@plan = Plan.find(params[:id])
	
		respond_to do |format|
		  if @plan.update_attributes(params[:plan])
		    format.html { redirect_to admin_plans_url, notice: 'Plan was successfully updated.' }
		    format.json { head :no_content }
		  else
		    format.html { render action: "edit" }
		    format.json { render json: @plan.errors, status: :unprocessable_entity }
		  end
		end
	end
	
	def destroy
		@plan = Plan.find(params[:id])
		@plan.destroy

	    respond_to do |format|
	      format.html { redirect_to admin_plans_url }
	      format.json { head :no_content }
	    end
	end
	
	private 
  	 def process_permissions_attrs
	  	 params[:plan][:object_permissions_attributes].values.each do |perm_attr|
		 	perm_attr[:_destroy] = true if perm_attr[:enable] != '1'
		 end
		 
	end

end
