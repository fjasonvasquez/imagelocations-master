class AssetEntity < ActiveRecord::Base
  attr_accessor :enable
  attr_accessible :id, :key, :meta, :priority, :asset_id, :site_id, :asset, :enable, :watermark_override
  #belongs_to :asset_entitable, :polymorphic => true
  #belongs_to :site_entity
  #belongs_to :taxonomy_term 
  belongs_to :asset, :inverse_of => :asset_entities
  
  
  belongs_to :image, :foreign_key => "asset_id", :class_name => "Image"
  belongs_to :video, :foreign_key => "asset_id"
  
  has_many :asset_versions, :through => :asset 
  
  
  belongs_to :site_entity, :inverse_of => :asset_entities, :touch => true
  has_one :site, :through => :site_entity
  
  belongs_to :asset_size, :foreign_key => :key, :primary_key => :key, :conditions => proc { "asset_sizes.site_id = #{Site.current.id}" }
  
  #has_one :asset_entity_version, :class_name => "AssetVersion", 
  
  attr_accessible :asset_attributes
  attr_accessible :image_attributes
  
  accepts_nested_attributes_for :asset, allow_destroy: true
  accepts_nested_attributes_for :image, allow_destroy: true
  
  scope :by_priority, :order => "asset_entities.priority ASC"
  
  validates :asset, :presence => true
  
  
  def key
  	value = read_attribute(:key)
    value.blank? ? nil : value.to_sym
  
  end
  
 
  def self.site(site)
  	joins(:site_entity).where(:site_entities => { :site_id => site})
  
  end
  
  def self.by_size(size_key)
  	includes(:asset => [:asset_versions => :asset_size]).where(:asset_sizes => {:key => size_key})
  end
  
   
  def self.by_key(*keys)
  	_order = [].tap do |o| 
  		keys.each do |k|
  			o << "asset_entities.key = '#{k.to_s}' DESC"
  		end
  		o << "asset_entities.priority ASC"
  	end.join(", ")
  		
  	where(:asset_entities => {:key => keys }).reorder(_order)
  	
  end
  
  def self.prepared_assets
  
  	joins("INNER JOIN assets ON asset_entities.asset_id = assets.id")
  	.select("asset_entities.id, asset_entities.key, assets.id AS asset_id, assets.source AS asset_source, assets.title AS asset_title")
  
  end
  
  def method_missing(method, *args)
    return asset.send(method, *args) if asset.respond_to?(method)
    super
  end
  
  def self.asset_load
  	select("asset_entities.id, asset_entities.key, asset_entities.asset_id, assets.id, assets.source AS source, assets.title, assets.type, assets.height, assets.width")
  	.joins(:asset)
  	.preload(:asset)
  	  end
  private
  def set_asset_if_available
  	unless self[:asset_source].nil?
  	
  		
  		set_asset = Asset.new :title => self[:asset_title], :source => self[:asset_source]
  		
  		
  	
  	end
  
  end
  
end
