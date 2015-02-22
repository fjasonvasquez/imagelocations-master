class Admin::PublicationsController < Admin::AdminController
	respond_to :html, :xml, :json
    
  def index
    @publications = apply_scopes(Publication).page(params[:page]).per(params[:per_page])
    respond_with @publications
  end


  def show
  	@publication = Publication.find(params[:id])
  	@tears = apply_scopes(@publication.tears).page(params[:page]).per(params[:per_page])
  	
  	respond_with @publication
  
  end
  
  def new
  	@publication = Publication.new
  end
  
  def edit
  	@publication = Publication.find(params[:id])
  end

  def create
  	 @publication = Publication.new(params[:publication])

    respond_to do |format|
      if @publication.save
        format.html { redirect_to admin_publications_url, notice: 'Tear was successfully created.' }
        format.json { render json: @publication, status: :created, location: admin_publications_url }
      else
        format.html { render action: "new" }
        format.json { render json: @publication.errors, status: :unprocessable_entity }
      end
    end

  end

  def update
  	@publication = Publication.find(params[:id])
   
    respond_to do |format|
      if @publication.update_attributes(params[:publication])
        format.html { redirect_to admin_publications_url, notice: 'Publication was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @publication.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
  	@publication = Publication.find(params[:id])
    @publication.destroy

    respond_to do |format|
      format.html { redirect_to admin_publications_url }
      format.json { head :no_content }
    end
  end
 
end
