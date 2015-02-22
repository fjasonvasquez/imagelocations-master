class Admin::CategoriesController < Admin::AdminController
  include EntityMethods::Controller

  has_scope :by_taxonomy
  has_scope :search
  respond_to :html, :xml, :json
  
  cache_sweeper :category_sweeper, :only => [:create, :update, :destroy]
  
  def index
    @categories = apply_scopes(Category).page(params[:page]).per(params[:per_page])
	
	@count = @categories.except(:limit,:offset).count
	
    respond_with @categories
  end

  # GET /categories/1
  # GET /categories/1.json
  def show
    @category = Category.find(params[:id])
    
    @locations = apply_scopes(@category.locations).page(params[:page]).per(params[:per_page])
    
    respond_with @category
  end

  # GET /categories/new
  # GET /categories/new.json
  def new
    @category = Category.new
	set_site_entities @category
	
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @category }
    end
  end

  # GET /categories/1/edit
  def edit
    @category = Category.find(params[:id])
    set_site_entities @category
    
    respond_with @category
  end

  # POST /categories
  # POST /categories.json
  def create
    @category = Category.new(params[:category])

    respond_to do |format|
      if @category.save
        format.html { redirect_to admin_categories_path, notice: 'Category was successfully created.' }
        format.json { render json: @category, status: :created, location: @category }
      else
      	set_site_entities @category
      	
        format.html { render action: "new" }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /categories/1
  # PUT /categories/1.json
  def update
    @category = Category.find(params[:id])

    respond_to do |format|
      if @category.update_attributes(params[:category])
        format.html { redirect_to admin_categories_path, notice: 'Category was successfully updated.' }
        format.json { head :no_content }
      else
      	set_site_entities @category
        format.html { render action: "edit" }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /categories/1
  # DELETE /categories/1.json
  def destroy
    @category = Category.find(params[:id])
    @category.destroy

    respond_to do |format|
      format.html { redirect_to admin_categories_path }
      format.json { head :no_content }
    end
  end

  def remove_site_scope?
	  true
  end
end
