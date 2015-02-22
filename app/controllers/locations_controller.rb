#require 'tmpdir'

class LocationsController < ApplicationController
  # GET /locations
  # GET /locations.json
  
  has_scope :site
  has_scope :by_city , :type => :array
  has_scope :by_permit, :type => :array
  has_scope :by_term, :type => :array
  has_scope :by_region, :type => :array
  has_scope :q, :only => [:search]
  
  before_filter :parse_params, :only => [:search]
  
  def index
   
  end

  def show
    @location = apply_scopes(Location).published().find(params[:id])
	
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @location }
    end
  end
  
  
  def search
  	@locations = apply_scopes(Location).published().page(params[:page]).per(params[:per_page])
  	#ap @locations.to_sql
  	#abort
  end
  
  def email
  	@email = Email.new(params[:share_email])
	@location = Location.find(params[:location])
	EntityMailer.location_email(@email,@location).deliver
	
  end
  
  
 
  
  def download
  	@location = Location.published().find(params[:id])
  	
  	_v = params[:version].to_sym
  	
  	_v = :gallery unless user_signed_in?
  	
  	
  	_site_v = AssetSize.to_version(_v,current_site.id)
  	  	
  	image_list = [].tap do |o|
  	  
  	  @location.current_assets_by_key(_v).each_with_index do |asset_entity, index|
  	  	_img =  asset_entity.asset.source
  	  	next unless _img.respond_to?(_site_v)
  	  	
  	  	_version = _img.send(_site_v)
  	  	
  	  	unless _version.file.exists?
  	  		_img.recreate_versions!(_site_v)
  	  	end
  	  	
  	  	o << _version.file

  	  end
  	end
  	  
    if !image_list.blank?
      file_name = sanitize_filename "#{@location.name}.zip"
      t = Tempfile.new("location-#{_site_v.to_s}-images-#{@location.id}-#{Time.now}")
      Zip::ZipOutputStream.open(t.path) do |z|
        image_list.each_with_index do |img, index|

          title = sanitize_filename("#{@location.name}-#{index}.#{img.extension.downcase}")
          z.put_next_entry(title)
		  z.write img.read
        end
      end
      send_file t.path, :type => 'application/zip',
                             :disposition => 'attachment',
                             :filename => file_name
      t.close
    else
    	redirect_to location_url(:id => @location.id)
    end
  end
  
  private
  
  def parse_params
  	[:by_city,:by_permit, :by_term, :by_region].each do |k|
	  	params[k].each do |p|
	  		params[k].delete(p) if p.to_i.zero?
	
	  	end if params[k].is_a?(Array)
	end
  	
  end
  
  def sanitize_filename(filename)
	  # Split the name when finding a period which is preceded by some
	  # character, and is followed by some character other than a period,
	  # if there is no following period that is followed by something
	  # other than a period (yeah, confusing, I know)
	  fn = filename.split /(?<=.)\.(?=[^.])(?!.*\.[^.])/m
	
	  # We now have one or two parts (depending on whether we could find
	  # a suitable period). For each of these parts, replace any unwanted
	  # sequence of characters with an underscore
	  fn.map! { |s| s.gsub /[^a-z0-9\-]+/i, '_' }
	
	  # Finally, join the parts with a period and return the result
	  return fn.join '.'
  end
  
end


