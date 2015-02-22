class Admin::BannerEntitiesController < Admin::AdminController
	has_scope :site
	respond_to :html, :xml, :json
	
	before_filter :set_banner_class
	before_filter :process_related_entity_attrs, only: [:update, :create] 
	before_filter :current_site_has_section
	
	cache_sweeper :banner_entity_sweeper, :only => [:create, :update, :reorder, :destroy]
	
	def index
		@banner_entities = apply_scopes(BannerEntity)
		
		respond_with @banner_entities
	end
	
	def edit
		@section = Section.find(params[:section_id])
		@banner_entity = BannerEntity.find(params[:id])
		respond_with @banner_entity
	end

	def new
		@section = Section.find(params[:section_id])
		@banner_entity = @klass.new(:section => @section )
		respond_with @banner_entity
	end
	
	def reorder
		params[:banner_entity_ids].each_with_index do |id, index|
			_b = BannerEntity.find(id)
			_b.priority = index+1
			_b.save
		end
		render nothing: true
	end
	def create

	    @banner_entity = @klass.new(params[:banner_entity])
		@banner_entity.section = @section
		
	    respond_to do |format|
	      if @banner_entity.save
	        format.html { redirect_to admin_section_path(@section), notice: 'New home banner has been created.' }
	        format.json { render json: @banner_entity, status: :created, location: admin_section_path(@section) }
	      else
	        format.html { render action: "new" }
	        format.json { render json: @banner_entity.errors, status: :unprocessable_entity }
	      end
	    end
	  end

	def update
	    @banner_entity = BannerEntity.find(params[:id])

	    respond_to do |format|
	      if @banner_entity.update_attributes(params[:banner_entity])
	        format.html { redirect_to admin_section_path(@section), notice: 'Home banner was successfully updated.' }
	        format.json { head :no_content }
	      else

	        format.html { render action: "edit" }
	        format.json { render json: @banner_entity.errors, status: :unprocessable_entity }
	      end
	    end
	end

	def destroy
	   @banner_entity = BannerEntity.find(params[:id])
	    @banner_entity.destroy
	
	    respond_to do |format|
	      format.html { redirect_to admin_section_path(@section) }
	      format.json { head :no_content }
	    end
	end
	 
	 private
	
	
	def banner_params
  		params[@klass.name.underscore.to_sym]
  	end
  
  	def set_banner_class  		  		
  		klass =  params[:banner_entity][:type] unless params[:banner_entity].nil?
        klass ||= params[:type]  			
  		klass = klass.nil? ? BannerEntity : klass.singularize.camelize.constantize
  		
  		@klass = BannerEntity.subclasses.include?(klass) ? klass : BannerEntity
  		
  		@klass
  		
  	end
	
	def current_site_has_section
		@section = current_site.sections.find_by_id(params[:section_id])
		
	 	redirect_to(admin_dashboard_url, notice: 'Current site does not have any banner sections.') if @section.nil?
	end
	 
  	def process_related_entity_attrs
	  	 params[:banner_entity][:banner_entity_site_entities_attributes].values.each do |perm_attr|
		 	perm_attr[:_destroy] = true if (perm_attr.has_key?(:enable) && perm_attr[:enable] != '1')
		 end unless params[:banner_entity][:banner_entity_site_entities_attributes].nil?	
	end
end
