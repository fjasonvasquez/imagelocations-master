class Video < Asset  
  
  
  has_one :asset_video
  
  mount_uploader :source, ImageUploader
  
  attr_accessible :asset_video_attributes, :video_source
  
  accepts_nested_attributes_for :asset_video, allow_destroy: false
  
  delegate :source, :to => :asset_video, :prefix => :video
  delegate :hosted?, :to => :asset_video, :prefix => :video
  
  def self.model_name
    Asset.model_name
  end
  #def mediaable_type
  def type
  	"video"
  end
  
  
end