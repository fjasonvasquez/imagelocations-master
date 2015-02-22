class LocationApplicationImage < ActiveRecord::Base
  attr_accessible :source, :source_cache
  
  mount_uploader :source, LocationApplicationImageUploader
  validates_presence_of :source
  validates_size_of :source, :maximum => 2.megabytes.to_i, :message => "should be less than 2MB"
  belongs_to :location_application
  
end
