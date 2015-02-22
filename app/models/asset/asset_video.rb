require 'active_support/inflector'
require 'cgi'
require 'uri'


class AssetVideo < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :video
  
  mount_uploader :source, VideoUploader
  
  attr_accessible :id, :source, :remove_source, :source_embed_url
  
  VIDEO_PROVIDERS = [:youtube]
  
  def hosted?
  	source.nil? && source_embed_url
  end
  
  def uri
  	URI(source_embed_url)
  end
  
  def uri_query
  	CGI.parse(uri.query)
  end
  
  def provider
  	index = VIDEO_PROVIDERS.find_index {|p| uri.host.include? p.to_s}
  	VIDEO_PROVIDERS[index] unless index.nil?
  end
  
  def host
  	uri.host
  end
  
  def embed_url
  	if self.respond_to?("#{provider.to_s}_embed_url".to_sym)
  		self.send("#{provider.to_s}_embed_url".to_sym)
  	else
  		source_embed_url
  	end
  end
  
  def youtube_embed_url
  	video_id = uri_query["v"][0]
  	ap uri_query
  	"http://www.youtube.com/embed/#{video_id}"
  end
  
  def width
  	640
  end 
  
  def height
  	390
  end
end
