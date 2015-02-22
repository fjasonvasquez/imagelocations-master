class Admin::ProjectsController < Admin::AdminController
  include EntityMethods::Controller
  
  has_scope :by_company
  has_scope :search
  
  respond_to :html, :xml, :json
  
  cache_sweeper :project_sweeper, :only => [:create, :update, :destroy]
    
  def index
    @projects = apply_scopes(Project).includes(:company).page(params[:page]).per(params[:per_page])
    respond_with @projects
  end


  def show
  	@project = Project.find(params[:id])
  	set_site_entities @project
  	@locations = [].tap do |o|
			@project.current_published_related_entities().includes(:site_entitable).reorder("related_site_entities.priority ASC").each {|se| o << se.site_entitable }
		end
  	#@locations = apply_scopes(@project.locations).page(params[:page]).per(params[:per_page])
  	
  	respond_with @project
  end
  def new
    @project = Project.new
    
    set_site_entities @project
    respond_with @project
  end
  
  def edit
  	@project = Project.find(params[:id])
  	set_site_entities @project
  end

  def create
    @project = Project.new(params[:project])

    respond_to do |format|
      if @project.save
        format.html { redirect_to admin_projects_url, notice: 'Project was successfully created.' }
        format.json { render json: @project, status: :created, location: admin_projects_url }
      else
      	set_site_entities @project
        format.html { render action: "new" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /locations/1
  # PUT /locations/1.json
  def update
    @project = Project.find(params[:id])
	
    respond_to do |format|
      if @project.update_attributes(params[:project])
        format.html { redirect_to admin_projects_url, notice: 'Project was successfully updated.' }
        format.json { head :no_content }
      else
      	set_site_entities @project
        format.html { render action: "edit" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def batch_destroy
  	
  	unless params[:project_ids].nil? || params[:project_ids].empty?
  	
	  	params[:project_ids].each do |id|
		  	_project = Project.find(id)
		  	
		  	_project.destroy
	  			
	  	end
  	
  	end
  	
  	respond_to do |format|
      format.html { redirect_to :back, notice: 'Projects have been deleted.' }
      format.json { head :no_content }
    end
  	
  end

  # DELETE /locations/1
  # DELETE /locations/1.json
  def destroy
  	@project = Project.find(params[:id])
  	#ap @project
  	#abort
    
    @project.destroy

    respond_to do |format|
      format.html { redirect_to :back }
      format.json { head :no_content }
    end
  end
end
