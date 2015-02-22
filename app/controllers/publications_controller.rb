class PublicationsController < ApplicationController
	#has_scope :site
	
	
	has_scope :site, :only => [:show]
	
	respond_to :html, :xml, :json
	
	caches_action :index, :expires_in => 10.minutes, :cache_path => Proc.new { |c| c.params.delete_if { |k,v| k.starts_with?('utm_') } }
	caches_action :show, :expires_in => 10.minutes, :cache_path => Proc.new { |c| c.params.delete_if { |k,v| k.starts_with?('utm_') } }
	
	def index
		@publications = apply_scopes(Publication).has_tears().order_by_category()
		
		respond_with @publications
	end
	
	def show
		@publication = Publication.find(params[:id])
		
		@tears = apply_scopes(@publication.tears).page(params[:page]).per(params[:per_page])
		
		respond_with @publication
	end

end
