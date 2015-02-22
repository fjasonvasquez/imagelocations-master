class Admin::PublicationCategoriesController < Admin::AdminController
	
  has_scope :search
  respond_to :html, :xml, :json
    
  def index
    @categories = apply_scopes(PublicationCategory).page(params[:page]).per(params[:per_page])
	
	
	#@categories = @categories.reorder().order_by_name("ASC") if params[:order_by].nil?
	
	@count = @categories.except(:limit,:offset).count
	
    respond_with @categories
  end

  # GET /categories/1
  # GET /categories/1.json
  def show
    @category = PublicationCategory.find(params[:id])
    
    @publications = apply_scopes(@category.publications).page(params[:page]).per(params[:per_page])
    
    respond_with @category
  end

  # GET /categories/new
  # GET /categories/new.json
  def new
    @category = PublicationCategory.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @category }
    end
  end

  # GET /categories/1/edit
  def edit
    @category = PublicationCategory.find(params[:id])
    
    respond_with @category
  end

  # POST /categories
  # POST /categories.json
  def create
    @category = PublicationCategory.new(params[:publication_category])

    respond_to do |format|
      if @category.save
        format.html { redirect_to admin_publication_categories_path, notice: 'PublicationCategory was successfully created.' }
        format.json { render json: @category, status: :created, location: @category }
      else      	
        format.html { render action: "new" }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /categories/1
  # PUT /categories/1.json
  def update
    @category = PublicationCategory.find(params[:id])

    respond_to do |format|
      if @category.update_attributes(params[:publication_category])
        format.html { redirect_to admin_publication_categories_path, notice: 'PublicationCategory was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /categories/1
  # DELETE /categories/1.json
  def destroy
    @category = PublicationCategory.find(params[:id])
    @category.destroy

    respond_to do |format|
      format.html { redirect_to admin_publication_categories_path }
      format.json { head :no_content }
    end
  end

  def remove_site_scope?
	  true
  end

end
