class Admin::SiteEntitiesController < Admin::AdminController
  respond_to :html, :xml, :json
  
  has_scope :site
  has_scope :type
  has_scope :slug
  has_scope :excluding_ids, :type => :array
  has_scope :search_by_location_name
  
  def index
  	@site_entities = apply_scopes(SiteEntity)
  	respond_with @site_entities
  
  end


  def destroy
    @site_entity = SiteEntity.find(params[:id])
    @site_entity.destroy
	
    respond_to do |format|
      format.html { redirect_to admin_locations_url }
      format.json { head :no_content }
    end
  end
end
