class Admin::SitesController < Admin::AdminController

	respond_to :html, :xml, :json
  
  def index
    @sites = apply_scopes(Site).includes(:memberships).page(params[:page]).per(params[:per_page])
    respond_with @sites
  end
  def show
    @site = Site.find(params[:id])
  end
  
  def edit
    @site = Site.find(params[:id])

  end
  
  def update
    @site = Site.find(params[:id])
    if @site.update_attributes(params[:site])
      redirect_to admin_sites_path, :notice => "site updated."
    else
      redirect_to admin_sitess_path, :alert => "Unable to update site."
    end
  end
    
  def destroy
    site = site.find(params[:id])
    unless site.memberships.count > 0
      site.destroy
      redirect_to admin_sites_path, :notice => "site deleted."
    else
      redirect_to admin_sites_path, :notice => "There are users with this site."
    end
  end
end
