class BannerEntitySiteEntity < ActiveRecord::Base
  attr_accessor :enable, :remove_banner
  attr_accessible :banner_entity_id, :related_site_entity, :related_site_entity_id, :priority, :banner, :site_entity, :options, :remove_banner
  
  belongs_to :banner_entity, :touch => TRUE
  belongs_to :site_entity, :foreign_key => :related_site_entity_id
  belongs_to :related_entity,  :class_name => "SiteEntity", :foreign_key => :related_site_entity_id
  
  serialize :options, Hash
  
  mount_uploader :banner, BannerUploader
  
  
  default_scope order("banner_entity_site_entities.priority ASC")
  
  scope :by_section, -> key { joins(:banner_entity => :section).where(:sections => {:key => key}) }
  
  scope :site, -> site { joins(:banner_entity => :section).where(:sections => {:site_id => site}) }
  
  scope :published, -> {
  		includes(:related_entity)
  		.where("site_entities.status = ? OR (site_entities.id IS NULL AND banner_entities.type = ?)",SiteEntity.published_status,"CustomBannerEntity")
  	}
  
end
