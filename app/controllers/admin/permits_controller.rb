class Admin::PermitsController < Admin::AdminController
  include EntityMethods::Controller
  has_scope :search
  respond_to :html, :xml, :json

  cache_sweeper :permit_sweeper, :only => [:create, :update, :destroy]
  
  def index
  	@permits = apply_scopes(Permit).page(params[:page]).per(params[:per_page])
    respond_with @permits
  end
  
  def new
    @permit = Permit.new  
    set_site_entities @permit
    
  end
  
  def show
  	@permit = Permit.find(params[:id])
  	@locations = apply_scopes(@permit.locations).page(params[:page]).per(params[:per_page])
  end

  def edit
  	@permit = Permit.find(params[:id])
  	set_site_entities @permit
  end

  def create
  	@permit = Permit.new(params[:permit])

    respond_to do |format|
      if @permit.save
        format.html { redirect_to admin_permits_url, notice: 'permit was successfully created.' }
        format.json { render json: @permit, status: :created, permit: admin_permits_url }
      else
      	set_site_entities @permit
        format.html { render action: "new" }
        format.json { render json: @permit.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
  	@permit = Permit.find(params[:id])
   
    respond_to do |format|
      if @permit.update_attributes(params[:permit])
        format.html { redirect_to admin_permits_url, notice: 'permit was successfully updated.' }
        format.json { head :no_content }
      else
      	set_site_entities @permit
        format.html { render action: "edit" }
        format.json { render json: @permit.errors, status: :unprocessable_entity }
      end
    end
  end

  def delete
  end

  def remove_site_scope?
	  true
  end
end
