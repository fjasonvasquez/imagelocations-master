class Admin::RegionsController < Admin::AdminController
  include EntityMethods::Controller
  
  respond_to :html, :xml, :json
  before_filter :get_region_conditions, :only => [:new, :edit]
  
  before_filter :process_condition_attrs, only: [:create, :update]
  
  def index
  	@regions = apply_scopes(Region).page(params[:page]).per(params[:per_page])
    respond_with @regions
  end
  
  def new
    @region = Region.new  
    set_site_entities @region
  end
  
  def show
  	@region = Region.find(params[:id])
    @cities = apply_scopes(@region.region_cities).page(params[:page]).per(params[:per_page])
    respond_with @region
  end

  def edit
  	@region = Region.find(params[:id])
  	set_site_entities @region
  end

  def create
  	@region = Region.new(params[:region])

    respond_to do |format|
      if @region.save
        format.html { redirect_to admin_regions_url, notice: 'Region was successfully created.' }
        format.json { render json: @region, status: :created, region: admin_regions_url }
      else
      	set_site_entities @region
        format.html { render action: "new" }
        format.json { render json: @region.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
  	@region = Region.find(params[:id])
   
    respond_to do |format|
      if @region.update_attributes(params[:region])
        format.html { redirect_to admin_regions_url, notice: 'Region was successfully updated.' }
        format.json { head :no_content }
      else
      	set_site_entities @region
        format.html { render action: "edit" }
        format.json { render json: @region.errors, status: :unprocessable_entity }
      end
    end
  end

  def delete
  end
  
  
  private
  	def get_region_conditions
  		@countries = [].tap { |o| State.group_by_countries.each {|s| o << [Country.find_country_by_alpha2(s.country_alpha2).name,s.country_alpha2]} }
  	end
  	
  	def process_condition_attrs
  		params[:region][:country_region_conditions_attributes].values.each do |country_attr|
  			country_attr[:_destroy] = true if country_attr[:enable] != '1'
  		end
  		
  		params[:region][:state_region_conditions_attributes].values.each do |country_attr|
  			country_attr[:_destroy] = true if country_attr[:enable] != '1'
  		end
  		
  		params[:region][:city_region_conditions_attributes].values.each do |country_attr|
  			country_attr[:_destroy] = true if country_attr[:enable] != '1'
  		end
  	end
  	
end
