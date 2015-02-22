class Admin::LocationsController < Admin::AdminController
  include EntityMethods::Controller
  # GET /locations
  # GET /locations.json
  
  has_scope :site, :except => [:edit]
  
  has_scope :search_by_name
  has_scope :excluding_ids, :type => :array
  has_scope :search
  has_scope :by_category
  
 
  cache_sweeper :location_sweeper, :only => [:create, :update, :destroy]
  
  respond_to :html, :xml, :json, :js
  
  
  
  def index
    @locations = apply_scopes(Location.joins(:series)).page(params[:page]).per(params[:per_page])
    
    @locations = @locations.reorder().order_by_fullname("ASC") if params[:order_by].nil?
    
    @count = @locations.except(:limit,:offset).count
    
    respond_with @locations
  end

  # GET /locations/1
  # GET /locations/1.json
  def show
    @location = apply_scopes(Location).includes(:current_entity).includes(:series).find(params[:id])
    @site_entity = @location.current_entity
    
    respond_with @locations
  end

  # GET /locations/new
  # GET /locations/new.json
  def new
    @location = Location.new
    @location.build_series
    @city = @location.build_city
    
    set_site_entities @location
    
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @location }
    end
  end
  
  # GET /locations/1/edit
  def edit
  	
    @location = apply_scopes(Location).includes(:series).includes(:permit).includes(:city).joins(:site_entities).find(params[:id])
    
    set_site_entities @location

  end

  # POST /locations
  # POST /locations.json
  def create
    @location = Location.new(params[:location])
	
	
	
    respond_to do |format|
      if @location.save
        format.html { redirect_to admin_locations_url(:site => current_site.id), notice: 'Location was successfully created.' }
        format.json { render json: @location, status: :created, location: admin_locations_url(:site => current_site.id) }
      else
      
      	set_site_entities @location
      	
        format.html { render action: "new" }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /locations/1
  # PUT /locations/1.json
  def update
    @location = Location.find(params[:id])
    
    #abort
    respond_to do |format|
      if @location.update_attributes(params[:location])
        format.html { redirect_to :back, notice: 'Location was successfully updated.' }
        format.json { head :no_content }
      else
        set_site_entities @location
        format.html { render action: "edit" }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /locations/1
  # DELETE /locations/1.json
  def destroy
    @location = apply_scopes(Location).find(params[:id])
    @location.destroy

    respond_to do |format|
      format.html { redirect_to admin_locations_url(:site => current_site.id) }
      format.json { head :no_content }
    end
  end
  
  def geocode
  
  
  end
  
  
  def sort_tears
  	@location = Location.find(params[:id])
  	
  	@tears = @location.tears.by_order
  	
  end

  
  def send_images
  	@location = apply_scopes(Location).find(params[:id])
  
  end
  
  def process_send_images
  	@location = Location.find(params[:id])
  	
  	_version = params[:version]
  	
  	@email = Email.new(params[:share_email])
	
	respond_to do |format|
	  if EntityMailer.location_download_email(@email,@location, _version).deliver
	    
	    format.js {
		    flash[:notice] = "Email has been sent"
	    }
	    format.html { redirect_to admin_locations_url(:site => current_site.id) , :notice => "Email has been sent"}
	  else
	    format.js { }
	    format.html { redirect_to admin_locations_url(:site => current_site.id), :error => "Email could not be sent" }      
	  end
	end  	
  end
end
