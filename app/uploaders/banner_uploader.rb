# encoding: utf-8

class BannerUploader < CarrierWave::Uploader::Base
  include CarrierWave::Uploader::Callbacks
  # Include RMagick or MiniMagick support:
  include CarrierWave::RMagick
  include CarrierWave::MimeTypes
  # include CarrierWave::MiniMagick

  # Include the Sprockets helpers for Rails 3.1+ asset pipeline compatibility:
  include Sprockets::Helpers::RailsHelper
  include Sprockets::Helpers::IsolatedHelper
  
  

  # Choose what kind of storage to use for this uploader:
  storage :file
  
  process :quality => 90
  
  # storage :fog
  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/banners/#{mounted_as}/#{model.id}"
  end
  
  def cache_dir
    '/tmp/imagelocations-cache'
  end
  

  
  
  
  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
     %w(jpg jpeg gif png)
  end

  def filename
  	"original.#{model.banner.file.extension}" if original_filename 
  end

  
end
