class Admin::TearsController < Admin::AdminController
  include EntityMethods::Controller
  respond_to :html, :xml, :json
    
  def index
    @tears = apply_scopes(Tear).page(params[:page]).per(params[:per_page])
    respond_with @tears
  end


  def show
  	@tear = Tear.find(params[:id])
  	respond_with @tear
  
  end
  
  def new
  	@tear = Tear.new
  	set_site_entities @tear
  end
  def edit
  	@tear = Tear.find(params[:id])
  	set_site_entities @tear
  end
  
  def reorder
  	params[:tear_ids].each_with_index do |id, index|
		_t = Tear.find(id)
		_t.order = index+1
		_t.save
	end
	render nothing: true
  
  end
  
  def create
  	 @tear = Tear.new(params[:tear])

    respond_to do |format|
      if @tear.save
        format.html { redirect_to admin_tears_url, notice: 'Tear was successfully created.' }
        format.json { render json: @tear, status: :created, location: admin_tears_url }
      else
      	set_site_entities @tear
        format.html { render action: "new" }
        format.json { render json: @tear.errors, status: :unprocessable_entity }
      end
    end

  end

  def update
  	@tear = Tear.find(params[:id])
   
    respond_to do |format|
      if @tear.update_attributes(params[:tear])
        format.html { redirect_to admin_tears_url, notice: 'Tear was successfully updated.' }
        format.json { head :no_content }
      else
      	set_site_entities @tear
        format.html { render action: "edit" }
        format.json { render json: @tear.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
  	@tear = Tear.find(params[:id])
    @tear.destroy

    respond_to do |format|
      format.html { redirect_to admin_tears_url }
      format.json { head :no_content }
    end
  end
end
