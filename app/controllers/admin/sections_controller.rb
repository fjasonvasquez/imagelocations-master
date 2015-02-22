class Admin::SectionsController < Admin::AdminController
	def index
	
	end
	
	def show
		@section = Section.find(params[:id])
		@banner_entities = apply_scopes(@section.banner_entities)
		
	end

end
