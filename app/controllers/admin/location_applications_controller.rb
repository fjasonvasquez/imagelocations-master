class Admin::LocationApplicationsController < Admin::AdminController

  include EntityMethods::Controller
  # GET /locations
  # GET /locations.json
  
  has_scope :site, :except => [:edit]
  
  has_scope :search
  
  respond_to :html, :json, :js
  
  
  
  def index
    @location_applications = apply_scopes(LocationApplication).page(params[:page]).per(params[:per_page])
   	  
    @count = @location_applications.except(:limit,:offset).count
    
    respond_with @location_applications
  end

  def show
    @location_application = apply_scopes(LocationApplication).includes(:location_application_images).find(params[:id])
    
    respond_with @locations
  end

  def destroy
    @location_application = apply_scopes(LocationApplication).find(params[:id])
    @location_application.destroy

    respond_to do |format|
      format.html { redirect_to admin_location_applications_url(:site => current_site.id) }
      format.json { head :no_content }
    end
  end

end
