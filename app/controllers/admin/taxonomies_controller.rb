class Admin::TaxonomiesController < Admin::AdminController
  
  
  respond_to :html, :xml, :json
  
  # GET /taxonomies
  # GET /taxonomies.json
  def index
    @taxonomies = apply_scopes(Taxonomy).page(params[:page]).per(params[:per_page])
	
	respond_with @taxonomies
    
  end

  # GET /taxonomies/1
  # GET /taxonomies/1.json
  def show
    @taxonomy = Taxonomy.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @taxonomy }
    end
  end

  # GET /taxonomies/new
  # GET /taxonomies/new.json
  def new
    @taxonomy = Taxonomy.new
	
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @taxonomy }
    end
  end

  # GET /taxonomies/1/edit
  def edit
    @taxonomy = Taxonomy.find(params[:id])
  end

  # POST /taxonomies
  # POST /taxonomies.json
  def create
    @taxonomy = get_taxonomy_class.new(params[:taxonomy])

    respond_to do |format|
      if @taxonomy.save
        format.html { redirect_to admin_taxonomies_path, notice: 'Taxonomy was successfully created.' }
        format.json { render json: @taxonomy, status: :created, location: @taxonomy }
      else
        format.html { render action: "new" }
        format.json { render json: @taxonomy.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /taxonomies/1
  # PUT /taxonomies/1.json
  def update
  	@klass = get_taxonomy_class
  	
    @taxonomy = Taxonomy.find(params[:id])
	
	@new_tax =  Taxonomy.find(params[:id]).becomes(@klass)

    respond_to do |format|
      if @new_tax.update_attributes(params[:taxonomy]) &&  @taxonomy.update_attribute(:type, @klass.name)
        format.html { redirect_to admin_taxonomies_path, notice: 'Taxonomy was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @taxonomy.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /taxonomies/1
  # DELETE /taxonomies/1.json
  def destroy
    @taxonomy = Taxonomy.find(params[:id])
    @taxonomy.destroy

    respond_to do |format|
      format.html { redirect_to admin_taxonomies_path, notice: 'Taxonomy has been deleted.' }
      format.json { head :no_content }
    end
  end
  
  private
  
  def get_taxonomy_class  		  		
  		klass =  params[:taxonomy][:type] unless params[:taxonomy].nil?
        klass ||= params[:type]
  		
  		klass = klass.nil? ? Taxonomy : klass.singularize.camelize.constantize
  		
  		klass = Taxonomy.subclasses.include?(klass) ? klass : Taxonomy
  	end

end
