class RegionsController < ApplicationController
	
	has_scope :site
	has_scope :region
	
	def show
		@region = Region.find(params[:id])
		@locations = apply_scopes(@region.locations).published().page(params[:page]).per(12).reorder("site_entities.priority DESC").order_by_fullname("ASC")
		
	end
end
