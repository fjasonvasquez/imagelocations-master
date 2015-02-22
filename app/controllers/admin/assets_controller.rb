class Admin::AssetsController < Admin::AdminController
  include EntityMethods::Controller
  #before_filter :process_taxonomy_attrs, only: [:create, :update]
  before_filter :set_asset_class
  before_filter :process_file, only: [:create]
  
  has_scope :excluding_ids, :type => :array
  
  respond_to :html, :json, :js
  
  def index
    @assets = apply_scopes(@klass).page(params[:page]).per(params[:per_page])
    
    respond_with @assets
    
  end
  
  def new
  	@asset = @klass.new
    respond_with @asset
  	# ap @asset.source.versions[:admin_thumb]
  end

  def create
  	@asset = @klass.new(params[:asset])
  	
    respond_to do |format|
      if @asset.save
        format.html { redirect_to admin_assets_path(:site => current_site.id, :type => @klass.name), notice: 'Asset was successfully created.' }
        format.json { render json: {:files => [@asset.to_jq_upload]}.to_json, status: :created, location: admin_locations_url(:site => current_site.id) }
      else
        format.html { render action: "new" }
        format.json { render json: {:error => @asset.errors}.to_json, status: :unprocessable_entity }
      end
    end

  end
  
  def edit
  	@asset = @klass.find(params[:id])
  	respond_with @asset
  end
  
  def update
    
    @asset = @klass.find(params[:id])
    
    if @asset.update_attributes(params[:asset])
      redirect_to admin_assets_path, :notice => "Asset updated."
    else
      redirect_to admin_assets_path, :alert => "Unable to update asset."
    end
  end
    
  def destroy
    
    asset = Asset.find(params[:id])
   
    if asset.destroy 
      respond_to do |format|
      	format.html { redirect_to admin_assets_path, :notice => "Asset deleted." }
      	format.json { head :no_content }
      	format.js { render nothing: true }
      	#format.js { render js }
      end
    else
      respond_to do |format|
      	format.html { redirect_to admin_assets_path, :notice => "Can't delete asset." }
      	format.json { head :no_content }
      	format.js { render nothing: true }
      end
    end
    
  end  

  def show
  	@asset = @klass.find(params[:id])
  end
  
  def remove_site_scope?
	  true
  end
	  
  private
  	def process_file
  		asset = @klass.new(params[:asset])
  		zipfile = params[:asset][:source]
  		
  		
  		if zipfile && File.extname(zipfile.original_filename).downcase == ".zip"
  			
  			asset = params[:asset].clone
  			asset.delete(:source)

  			assets = []
  			errors = []
  			
  			Zippy.each(zipfile.tempfile) do |name, file|
	  			
	  			next if file.nil? or name =~ /__MACOSX/ or name =~ /\.DS_Store/
	  			
	  			source = FilelessIO.new(file)
	  			source.original_filename = name
	  			
	  			new_asset = @klass.new(asset)
	  			
	  			new_asset.source = source
	  			new_asset.title = name
	  			if(new_asset.save)
	  				assets.push(new_asset.to_jq_upload)
	  			else	
	  				errors.push(new_asset.errors)
	  			end
	  		end
	  		
	  		 respond_to do |format|
		      if errors.empty?
		        format.html { redirect_to admin_assets_path(:site => current_site.id, :type => @klass.name), notice: 'Asset was successfully created.' }
		        format.json { render json: {:files => assets}.to_json, status: :created, location: admin_locations_url(:site => current_site.id) }
		      else
		      	
		        format.html { render action: "new" }
		        format.json { render json: {:error => errors}.to_json, status: :unprocessable_entity }
		      end
		    end
  		  		
			return;
  		end
  	end
  	
  	def asset_params
  		params[@klass.name.underscore.to_sym]
  	end
  
  	def set_asset_class  		  		
  		klass =  params[:asset][:type] unless params[:asset].nil?
  		klass ||= params[:type]
  		
  		klass = klass.nil? ? Asset : klass.singularize.camelize.constantize
  		
  		@klass = Asset.subclasses.include?(klass) ? klass : Asset
  	end
  	
  	def process_taxonomy_attrs
	  	params[:asset][:site_entity_attributes][:taxonomy_term_entities_attributes].values.each do |perm_attr|
		 	  perm_attr[:_destroy] = true if (perm_attr[:enable] != '1' && perm_attr.has_key?(:enable) || perm_attr[:taxonomy_term_id].blank? && !perm_attr.has_key?(:enable))
		  end
	  end

end

class FilelessIO < StringIO
    attr_accessor :original_filename
end
