class AssetVersion < ActiveRecord::Base
  attr_accessible :asset, :asset_size, :processed, :height, :width
  
  attr_accessor :watermark_override
  
  belongs_to :asset
  belongs_to :asset_size, :inverse_of => :asset_versions
  
  has_one :site, :through => :asset_size
  
  scope :by_asset_size, proc {|key| joins(:asset_size).where(:asset_sizes => {:key => key })}
  
  scope :by_current_site, proc { joins(:asset_size).where(:asset_sizes => {:site_id => Site.current.id })}
  
  def dimensions
  	process_if_needed
  	{:height => self.height, :width => self.width}
  end
  
  def ratio
  	process_if_needed
  	self.height.to_f / self.width.to_f
  end
  
  
  
  def process
  	if self.asset.source.file.exists?
  		
  		
    	self.asset.source.recreate_versions!(self.asset_size.version)
    	
    	self.asset.source.recreate_versions!(self.asset_size.version_unmarked) if self.asset_size.watermark?
    	
		self.processed = true
		
		version = self.asset.source.retrieve_version(self.asset_size.version)
  		
  		self.height = version.geometry[:height]
  		self.width = version.geometry[:width]
		self.save!
	end
  end
  
  def unprocess
  	self.processed = false
  	self.height = 0
  	self.width = 0
  	save!
  end
  
  
  def self.unprocess_all
  	self.update_all( "processed = 'f', height = 0, width = 0" )
  end
  
  def self.unprocessed
  	where(:processed => FALSE)
  
  end
  
  private
  	def process_if_needed
  		if self.processed == false
  			process
  		end
  	end
end
