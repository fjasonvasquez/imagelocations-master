class Permit < ActiveRecord::Base
  include EntityMethods::Model
  allow_site_entities true
  
  attr_accessible :name, :label, :logo, :remove_logo
  
  mount_uploader :logo, LogoUploader
  
  has_many :locations
  
  validates_presence_of :name
  
  def self.search(string)
  	condition = ["%" + string.downcase + "%"]
  	where("LOWER(name) LIKE ?",condition)
  end
  
end
