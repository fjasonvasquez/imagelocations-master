class Asset < ActiveRecord::Base
  class << self
	def new_with_cast(*attributes, &block)
		if (h = attributes.first).is_a?(Hash) && !h.nil? && (type = h[:type] || h['type']) && type.length > 0 && (klass = type.constantize) != self
		  raise "wtF hax!!"  unless klass <= self
		  return klass.new(*attributes, &block)
		end
		
		new_without_cast(*attributes, &block)
	end
	alias_method_chain :new, :cast

  end
    
  include Rails.application.routes.url_helpers
  
  include EntityMethods::Model
  
  allow_site_entities false
  
  attr_accessor :current_version
  
  attr_accessible :id, :source, :remove_source, :type, :title, :height, :width, :site_entity, :current_version, :photographer_id
  
  has_many :asset_entities, :inverse_of => :asset, :dependent => :delete_all, :inverse_of => :asset
  
  has_many :asset_versions, :dependent => :destroy
  
  belongs_to :photographer
  
  before_create :set_asset_title
  before_create :create_asset_versions
  
  before_save :update_asset_attributes, :if => :source_changed?
  before_save :update_asset_dimensions, :if => :source_changed?
  
  
  after_save :check_source_changed
   
  validates_presence_of :source
  
  default_scope order('created_at DESC')
  
  scope :excluding_ids, lambda { |ids| where(['assets.id NOT IN (?)', ids]) if ids.any? }

  def to_jq_upload
  end
  
  def type
  	"asset"
  end
  
  def recreate_version(version)
  
  	source.recreate_versions!(version)
  end	
    
  def to_jq_upload
    {
      "id" => id,
      "name" => read_attribute(:source),
      "size" => source.size,
      "url" => source.url,
      "thumbnail_url" => source.thumb.url,
      "edit_url" => edit_admin_asset_path(id,:js),
      "delete_url" => admin_asset_path(:id => id, :type => type),
      "delete_type" => "DELETE" 
    }
  end
  
  def version(key)
  	
  	 v = current_version || asset_versions.readonly(false).by_current_site().by_asset_size(key).first
  	 
  	 v ||= begin
  	 	asset_versions.new({:asset_size => Site.current.asset_sizes.find_by_key(key)})
  	 end
  	 
  end
  
  def set_asset_dimensions
  	update_asset_dimensions
  end
  
  private
   
  def check_source_changed
  	asset_versions.readonly(false).find_each do |v|
  		v.unprocess
  	end if self.source_changed?
  end 
  
  def set_asset_title
  	self.title ||= File.basename(self.source.path, ".*")
  end 
  
  def create_asset_versions
  	
  	asset_versions.build([].tap {|o| AssetSize.find_each {|as| o << {:asset_size => as } }})
  
  end
  
  def update_asset_attributes
    if source.present?
      self.content_type = source.file.content_type
      self.file_size = source.file.size      
    end
  end
  
  def update_asset_dimensions
  	if source.present? && source.respond_to?(:geometry)
      self.height = source.geometry[:height]
      self.width = source.geometry[:width]      
    end
  end
   	
end