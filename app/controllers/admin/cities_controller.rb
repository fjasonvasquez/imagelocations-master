class Admin::CitiesController < Admin::AdminController
  include EntityMethods::Controller
  respond_to :html, :xml, :json
  has_scope :by_state
  has_scope :by_state_name
  has_scope :by_country
  has_scope :find_by_name
  has_scope :search
  
  cache_sweeper :city_sweeper, :only => [:create, :update, :destroy]
  
  def index
  	@cities = apply_scopes(City).page(params[:page]).per(params[:per_page])
    respond_with @cities
  end

  def show
    @city = City.find(params[:id])
    @locations = apply_scopes(@city.locations).page(params[:page]).per(params[:per_page])
    respond_with @city
  end
  
  def edit
  	@city = City.find(params[:id])
  	set_site_entities @city
  	respond_with @city
  
  end
  
  def update
  	@city = City.find(params[:id])
   
    respond_to do |format|
      if @city.update_attributes(params[:city])
        format.html { redirect_to admin_state_path(@city.state), notice: 'City was successfully updated.' }
        format.json { head :no_content }
      else
      	set_site_entities @city
        format.html { render action: "edit" }
        format.json { render json: @city.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
  	@city = City.find(params[:id])

    respond_to do |format|
	    if @city.destroy
			format.html { redirect_to admin_state_path(@city.state) }
			format.json { head :no_content }
		else
			format.html { redirect_to admin_state_path(@city.state) }
			format.json { render json: @city.errors, status: :unprocessable_entity }
	      
	    end
	 end
  end
  
  def remove_site_scope?
	  true
  end

end
