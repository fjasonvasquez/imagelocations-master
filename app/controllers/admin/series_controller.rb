class Admin::SeriesController < Admin::AdminController
  include EntityMethods::Controller
  
  has_scope :site, :if => -> controller { controller.params[:format].nil? || controller.params[:format] == "html" }
  has_scope :search
  has_scope :location
  
  respond_to :html, :xml, :json
  #respond_to :json
  def index
    @series = apply_scopes(Series).includes(:locations).page(params[:page]).per(params[:per_page])
    #render :json => @series
    respond_with @series
  end

  def show
    @series = Series.find(params[:id])
  	@locations = apply_scopes(@series.locations).page(params[:page]).per(params[:per_page])
  end
  
  def edit
    @series = Series.find(params[:id])
    set_site_entities @series
  end
  
  def update
    @series = Series.find(params[:id])
    if @series.update_attributes(params[:series])
      redirect_to admin_series_path, :notice => "Series updated."
    else
    	set_site_entities @series
    	redirect_to admin_series_path, :alert => "Unable to update role."
    end
  end
    
  def destroy
    series = Series.find(params[:id])
    unless series.locations.count > 0
      series.destroy
      redirect_to admin_series_path, :notice => "Series deleted."
    else
      redirect_to admin_series_path, :notice => "This Series cannot be deleted"
    end
  end
  

end
