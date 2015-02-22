class CategoriesController < ApplicationController
	
	has_scope :site
	has_scope :region

	has_scope :by_letter
	has_scope :by_city
	
	has_scope :by_term, :only => [:show]
	
	has_scope :by_permit
	
	respond_to :html, :js
	
	#caches_action :show, :cache_path => Proc.new { |c| c.params }
	caches_action :index, :cache_path => Proc.new { |c| c.params.delete_if { |k,v| k.starts_with?('utm_') } }
	
	caches_action :show, :cache_path => Proc.new { |c| c.params.delete_if { |k,v| k.starts_with?('utm_') } }
	
	def index
		
		@featured_categories = apply_scopes(Category).special().published().select("categories.id, categories.name, categories.type, categories.updated_at")
		
		
		@featured_categories += apply_scopes(Category).published().by_field("featured",1).select("categories.id, categories.name, categories.updated_at")
		
		
		@categories = apply_scopes(Category).published().order("categories.name ASC").page(params[:page]).per(per_page)
		
		#@categories_list = apply_scopes(Category).is_published().select("categories.id, categories.name").order("categories.name ASC")
		@categories_list = @categories.except(:limit, :offset).select("categories.id, categories.name").order("categories.name ASC")
		
		respond_with @categories
	end
	
	def show
		@category = Category.published().find(params[:id])
		@category.series_id ||= 0
		
		@locations = apply_scopes(@category.locations)
		.published()
		.includes(:current_asset_entities)
		.reorder("site_entities.priority DESC, series.id = #{@category.series_id} DESC, series.name ASC, locations.series_number ASC").page(params[:page]).per(params[:per_page])
		
		#@locations.each do |l|
		
		#	ap l.current_asset_entities
		
		#end
		
		#abort
		
		#ap @locations.scoped.taxonomy_terms
		#exit
		@cities = @category.cities.select("cities.id,cities.name").order("cities.name ASC")
		@terms = TaxonomyTerm.current_entity_terms(Location, @locations.except(:limit).except(:order).select("locations.id").all)
		#@terms = @category.locations_taxonomy_terms
		#@terms = TaxonomyTerm.limit(10)
		
		#render layout: false
		respond_with @locations
	end
	
	
	
	
	def email
  		@email = Email.new(params[:share_email])
		@category = Category.find(params[:category])
		#EntityMailer.current_hostname = "new.imagelocation.com"
		EntityMailer.category_email(@email,@category).deliver
	end
	
	private
	
	def has_views
		case action_name
			when "show"
				[:quick]
		end
	
	end
	
	def per_page
		case action_name
			when "index"
				12
			when "show"
				params[:per_page]
		end
	end
end
