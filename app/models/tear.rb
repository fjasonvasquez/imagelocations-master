class Tear < ActiveRecord::Base
  include EntityMethods::Model
  allow_site_entities true
  
  attr_accessible :name, :description, :order, :cover, :remove_cover, :location_id, :publication_id
  
  mount_uploader :cover, CoverUploader
  
  belongs_to :publication, :touch => true
  belongs_to :location
  
  validates_presence_of :name
  
  scope :newest, proc { order("tears.updated_at DESC")}
  
  scope :by_order, proc { order("tears.`order` ASC")}
  
  scope :has_cover, proc { where("tears.cover IS NOT NULL")}
  
end
