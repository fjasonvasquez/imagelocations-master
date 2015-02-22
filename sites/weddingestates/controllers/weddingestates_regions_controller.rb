class WeddingestatesRegionsController < RegionsController
	
	has_scope :site
	
	has_scope :is_not_private, :type => :boolean, :only => :show
	has_scope :is_private, :type => :boolean, :only => :show
	
	before_filter :process_private_param, :only => :show
	
	
	def index
      @region_entities = apply_scopes(BannerEntity).published().by_section(:regions).includes(:banner_entity_site_entities => :site_entity)
	end
	

	def show
		super
	
	end
	
	
	def process_private_param
		
		
		params[:is_not_private] = !user_is_subscribed? && params[:private].nil? if !user_is_subscribed? && params[:private].nil?
		
		params[:is_private] = true if !params[:private].nil?
		
	end

end
