class Admin::CompaniesController < Admin::AdminController

	  respond_to :html, :xml, :json
    
  def index
    @companies = apply_scopes(Company).page(params[:page]).per(params[:per_page])
    respond_with @companies
  end


  def show
  	@company = Company.find(params[:id])
  	#set_site_entities @company  	
  	respond_with @company
  end
  def new
    @company = Company.new
    
    #set_site_entities @company
  end
  
  def edit
  	@company = Company.find(params[:id])
  	#set_site_entities @company
  end

  def create
    @company = Company.new(params[:company])

    respond_to do |format|
      if @company.save
        format.html { redirect_to admin_companies_url, notice: 'Company was successfully created.' }
        format.json { render json: @company, status: :created, location: admin_companies_url }
      else

        format.html { render action: "new" }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /locations/1
  # PUT /locations/1.json
  def update
    @company = Company.find(params[:id])
	
    respond_to do |format|
      if @company.update_attributes(params[:Company])
        format.html { redirect_to admin_companies_url, notice: 'Company was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /locations/1
  # DELETE /locations/1.json
  def destroy
    @company = Company.find(params[:id])
    @company.destroy

    respond_to do |format|
      format.html { redirect_to admin_companies_url }
      format.json { head :no_content }
    end
  end
end
