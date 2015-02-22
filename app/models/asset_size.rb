class AssetSize < ActiveRecord::Base
  attr_accessible :site, :site_id, :key, :process, :height, :width, :watermark
  
  has_many :asset_versions, :inverse_of => :asset_size, :dependent => :delete_all
  
  belongs_to :site
  
  scope :by_key, proc {|key| where("asset_sizes.key = ?",key)}
  
  scope :site, proc {|key| where("asset_sizes.site_id = ?",key)}
   
  def process
  	self[:process].to_sym
  end
  
  def dimensions
  	[width,height]
  end
  
  def version_unmarked
	  self.class.to_version_unmarked(key,site_id)
  end
  
  def version
  	#"#{key}_#{site_id}".to_sym
  	self.class.to_version(key,site_id)
  end
  
  def watermark
  	img_root = "#{Rails.root}/sites/#{site.namespace}/assets/images/#{site.namespace}"
  	img = File.exist?("#{img_root}/watermark_#{key}.png") ? "#{img_root}/watermark_#{key}.png" : "#{img_root}/watermark.png"
  	
  	if self[:watermark] && File.exist?(img)
  		img
  	end  
  end
  def self.table_exists?
  	ActiveRecord::Base.connection.table_exists? "asset_sizes"
  end
  
  
  def self.to_version(key, site_id)
  	"#{key}_#{site_id}".to_sym
  end
  
  def self.to_version_unmarked(key, site_id)
  	"#{self.to_version(key,site_id).to_s}_unmarked".to_sym
  end
  
end
