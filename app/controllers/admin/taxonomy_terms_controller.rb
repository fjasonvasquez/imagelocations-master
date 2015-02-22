class Admin::TaxonomyTermsController < Admin::AdminController
  include EntityMethods::Controller
  # GET /taxonomy_terms
  # GET /taxonomy_terms.json
  has_scope :by_taxonomy
  has_scope :search
  
  respond_to :html, :xml, :json
  
  def index
    @taxonomy_terms = apply_scopes(TaxonomyTerm).page(params[:page]).per(params[:per_page])

    respond_with @taxonomy_terms
  end

  # GET /taxonomy_terms/1
  # GET /taxonomy_terms/1.json
  def show
    @taxonomy_term = TaxonomyTerm.find(params[:id])
    
    @locations = apply_scopes(@taxonomy_term.locations).uniq().page(params[:page]).per(params[:per_page])
    

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @taxonomy_term }
    end
  end

  # GET /taxonomy_terms/new
  # GET /taxonomy_terms/new.json
  def new
    @taxonomy_term = TaxonomyTerm.new
	set_site_entities @taxonomy_term
	
	respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @taxonomy_term }
    end
  end

  # GET /taxonomy_terms/1/edit
  def edit
    @taxonomy_term = TaxonomyTerm.find(params[:id]) 
    set_site_entities @taxonomy_term
    
  end

  # POST /taxonomy_terms
  # POST /taxonomy_terms.json
  def create
    @taxonomy_term = TaxonomyTerm.new(params[:taxonomy_term])

    respond_to do |format|
      if @taxonomy_term.save
        format.html { redirect_to admin_taxonomy_term_path(@taxonomy_term), notice: 'Taxonomy term was successfully created.' }
        format.json { render json: @taxonomy_term, status: :created, location: @taxonomy_term }
      else
      	set_site_entities @taxonomy_term
      	
        format.html { render action: "new" }
        format.json { render json: @taxonomy_term.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /taxonomy_terms/1
  # PUT /taxonomy_terms/1.json
  def update
    @taxonomy_term = TaxonomyTerm.find(params[:id])

    respond_to do |format|
      if @taxonomy_term.update_attributes(params[:taxonomy_term])
        format.html { redirect_to admin_taxonomy_terms_path , notice: 'Taxonomy term was successfully updated.' }
        format.json { head :no_content }
      else
      	set_site_entities @taxonomy_term
        format.html { render action: "edit" }
        format.json { render json: @taxonomy_term.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /taxonomy_terms/1
  # DELETE /taxonomy_terms/1.json
  def destroy
    @taxonomy_term = TaxonomyTerm.find(params[:id])
    @taxonomy_term.destroy

    respond_to do |format|
      format.html { redirect_to admin_taxonomy_terms_path }
      format.json { head :no_content }
    end
  end
  
  def remove_site_scope?
	  true
  end
end
