class Admin::PhotographersController < Admin::AdminController
  include EntityMethods::Controller
  has_scope :search
  
  cache_sweeper :permit_sweeper, :only => [:create, :update, :destroy]
  
  def index
  	@photographers = apply_scopes(Photographer).page(params[:page]).per(params[:per_page])
    #respond_with @photographers
  end
  
  def new
    @photographer = Photographer.new  
    set_site_entities @photographer
    
  end
  
  def show
  	@photographer = Photographer.find(params[:id])
  	@locations = apply_scopes(@photographer.locations).page(params[:page]).per(params[:per_page])
  end

  def edit
  	@photographer = Photographer.find(params[:id])
  	set_site_entities @photographer
  end

  def create
  	@photographer = Photographer.new(params[:photographer])

    respond_to do |format|
      if @photographer.save
        format.html { redirect_to admin_photographers_url, notice: 'permit was successfully created.' }
        format.json { render json: @photographer, status: :created, permit: admin_photographers_url }
      else
      	set_site_entities @photographer
        format.html { render action: "new" }
        format.json { render json: @photographer.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
  	@photographer = Photographer.find(params[:id])
   
    respond_to do |format|
      if @photographer.update_attributes(params[:permit])
        format.html { redirect_to admin_photographers_url, notice: 'permit was successfully updated.' }
        format.json { head :no_content }
      else
      	set_site_entities @photographer
        format.html { render action: "edit" }
        format.json { render json: @photographer.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @photographer = apply_scopes(Photographer).find(params[:id])
    @photographer.destroy

    respond_to do |format|
      format.html { redirect_to admin_photographers_url(:site => current_site.id) }
      format.json { head :no_content }
    end
  end

  def remove_site_scope?
	  true
  end
	  
	  
	
end
