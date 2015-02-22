# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::Uploader::Callbacks
  # Include RMagick or MiniMagick support:
  include CarrierWave::RMagick
  include CarrierWave::MimeTypes
  # include CarrierWave::MiniMagick

  # Include the Sprockets helpers for Rails 3.1+ asset pipeline compatibility:
  include Sprockets::Helpers::RailsHelper
  include Sprockets::Helpers::IsolatedHelper
  
  
  before :cache, :setup_available_sizes
  
  process :set_content_type
  
  # Choose what kind of storage to use for this uploader:
  storage :file

  after :remove, :remove_empty_store_dir
  
  # storage :fog
  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  #def filename
  	
  	
  	#ap original_filename
  #	"#{model.id}_#{model.title}.#{model.source.file.extension}" if original_filename 
  #end
  

  def store_dir
    "#{base_store_dir}/#{first_level_store_dir}/#{model.id}"
  end
  
  def base_store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}"
  end
  
  def first_level_store_dir
  	"#{(model.id.to_f / 31999).ceil}"
  end

  def cache_dir
    '/tmp/imagelocations-cache'
  end
  
  def remove_empty_store_dir
  	path = ::File.expand_path(store_dir, root)
  	Dir.delete(path)
  	
  	path = ::File.expand_path("#{base_store_dir}/#{first_level_store_dir}", root)
  	Dir.delete(path)
  	
  	
  	path = ::File.expand_path(base_store_dir, root)
  	Dir.delete(path)
  	
  	rescue SystemCallError
    	true
  end
  
      
  # Provide a default URL as a default if there hasn't been a file uploaded:
  #def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  	#"/holder.js"
  	#asset_path("javascripts/" + [version_name, "holder.js"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  #end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end
  DEFAULT_VERSIONS = {
  	:tiny => { 
  		:resize_to_fill => [50,50],
	  	:convert => 'png'
	},  		
  	:thumb => { 
  		:resize_to_fill => [200,200],
	  	:convert => 'png'
	},
	:medium => { 
  		:resize_to_fit => [320,220],
	  	:convert => 'png'
	},
	:pdf => { 
  		:resize_to_limit => [320,220],
	  	:convert => 'jpg',
	  	:quality => 84
	},
	:large => { 
  		:resize_to_fit => [700,500],
	  	:convert => 'jpg',
	  	:quality => 84
	}
  }
  
  DEFAULT_VERSIONS.each do |v, val|
  	version v do
  		attr_accessor :v
  		val.each do |k,p|
  			process k => p
  		end
  		
  		#def store_dir
  		#	"#{base_store_dir}/default_versions"
  		#end
  		#process val[:process] => val[:args]
  	end
  end
  
  AssetSize.all.each do |asset_size|
  	  
      version asset_size.version, :if => :is_lazy? do
        attr_accessor :asset_size
        attr_accessor :watermarked

      	process :quality => 80
      	process :process_dynamic_asset
      	
      	define_method(:asset_size) { asset_size }
	  	define_method(:watermarked) { true }
      end
      
      
      version asset_size.version_unmarked, :if => :is_lazy? do
        attr_accessor :asset_size
        attr_accessor :watermarked

      	process :quality => 80
      	process :process_dynamic_asset
      	
      	define_method(:asset_size) { asset_size }
      	
      	define_method(:watermarked) { false }

      end if asset_size.watermark?
      
  end unless !AssetSize.table_exists?

  
  def is_lazy?(file)
  	!model.new_record? || !model.source_changed?
  end
  
  def process_dynamic_asset
	 
  	send(asset_size.process,*asset_size.dimensions) do |img|
  		#ap img.columns
  		#ap img.rows
  		unless asset_size.watermark.nil? or !watermarked
    		logo = Magick::Image.read(asset_size.watermark).first
    	
			img = img.composite(logo, Magick::SouthEastGravity, 15, 0, Magick::OverCompositeOp)
		end
		img
	end if respond_to?(asset_size.process)
  end

  # Create different versions of your uploaded files:
  # version :admin_thumb do
#   	process :resize_to_fill => ADMIN_VERSIONS[:admin_thumb]
#     process :convert => 'png' 
#   end
#   
#   version :admin_wide do
#   	process :resize_to_fill => ADMIN_VERSIONS[:admin_thumb]
#     process :convert => 'png' 
#   end
#   
#   version :admin_large do
#   	process :resize_to_fill => ADMIN_VERSIONS[:admin_large]
#   end
  
  
  process :dynamic_resize_to_fit => :default
  
  
  def dynamic_resize_to_fit(size)
  	asset_size = AssetSize.find_by_key(size)

    resize_to_fit *(asset_size.dimensions) unless asset_size.nil?
  end
  
  
  def method_missing(method, *args)
    # we've already defined "has_VERSION_size?", so if a method with
    # similar name is missed, it should return false
    return false if method.to_s.match(/has_(.*)_size\?/)
    super
  end
  #process :store_geometry
  def geometry
    @geometry ||= get_geometry
  end
  
  def get_geometry
    if @file
      img = ::Magick::Image::read(@file.file).first
      geometry = { width: img.columns, height: img.rows }
    end
  end
  
  
  def retrieve_version(version)
  	versions[version.to_sym] unless versions[version.to_sym].nil?
  end
  
  def retrieve_model_version(version)
  	model.version(version)
  end
  
  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
     %w(jpg jpeg gif png)
  end

  def safe_version(version_name)
  	  _version = send(version_name) if respond_to?(version_name)
  	  
  	  
	  unless _version.nil? || File.exist?(_version.path)
	  	recreate_versions!(version_name)
	  end
	  	  
	  _version
  end
  
  def self.define_version(version_title, width, height)
  	version version_title do
    	process :resize_to_limit => [width, height]
    end
  end
  
  def self.version_dimensions(version)
  	DEFAULT_VERSIONS[version]
  end
  
  
  def url(options = {}, unwatermarked = false)

  	if options && versions[options].nil? && options.is_a?(Symbol)
  
  		_original = options	  		
	  	options = unwatermarked ? AssetSize.to_version_unmarked(_original,Site.current.id) : AssetSize.to_version(_original,Site.current.id)
	  	
	  	if unwatermarked && versions[options].nil?
		  	options = AssetSize.to_version(_original,Site.current.id)
		end
	  	
  		unless versions[options].nil? || File.exist?(versions[options].path)
  			current_version = model.version(_original)
  			
  			current_version.process unless current_version.nil? || ( current_version.processed && !unwatermarked )
  		end


  	end
  	#ap options
  	super(options)
  	
  end
  
  protected
  
  
  def setup_available_sizes(file)
  
    AssetSize.all.each do |size|
    	

      self.class_eval do
      	
        define_method("has_#{size.key}_size?".to_sym) { true }
        
      end
      
      
    end
  end
  
end
