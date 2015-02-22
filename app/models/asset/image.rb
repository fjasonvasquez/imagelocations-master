class Image < Asset
  include Rails.application.routes.url_helpers
  
  mount_uploader :source, ImageUploader
  
  def self.model_name
    Asset.model_name
  end
  #def mediaable_type
  def type
  	"image"
  end
  
  
end