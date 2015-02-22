# encoding: utf-8

class LocationApplicationImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::Uploader::Callbacks
  # Include RMagick or MiniMagick support:
  include CarrierWave::RMagick
  include CarrierWave::MimeTypes
  # include CarrierWave::MiniMagick

  # Include the Sprockets helpers for Rails 3.1+ asset pipeline compatibility:
  include Sprockets::Helpers::RailsHelper
  include Sprockets::Helpers::IsolatedHelper
  
  
  #before :cache, :setup_available_sizes
  
  #process :set_content_type
  
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
    "#{base_store_dir}/#{first_level_store_dir}/#{model.location_application.id}"
  end
  
  def base_store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}"
  end
  
  def first_level_store_dir
  	"#{(model.id.to_f / 31999).ceil}"
  end

  def cache_dir
  	Rails.root.join 'public/uploads/tmp'
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
  	:thumb => { 
  		:resize_to_fill => [200,200],
	  	:convert => 'jpg'
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
  
  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
     %w(jpg jpeg gif png)
  end
  
end
