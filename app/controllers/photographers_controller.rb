class PhotographersController < ApplicationController
	has_scope :site
	has_scope :is_published
	
	def index
		@photographers = apply_scopes(Photographer).published()
		
		ap @photographers
		
	end
	
	
	def show
		
		@photographer = apply_scopes(Photographer).published().find(params[:id])
		
		@locations = apply_scopes(@permit.locations).published().includes(:city).includes(:permit).includes(:assets).page(params[:page]).per(12)
		

	end
end
