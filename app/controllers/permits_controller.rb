class PermitsController < ApplicationController
	has_scope :site
	has_scope :region
	has_scope :is_published
	has_scope :by_letter
	has_scope :by_city
	
	has_scope :by_term, :only => [:show]
	
	has_scope :by_permit
	
	respond_to :html, :js
	
	#caches_action :show, :cache_path => Proc.new { |c| c.params.delete_if { |k,v| k.starts_with?('utm_') } }
	
	def index

	end
	
	def show
		@permit = Permit.find(params[:id])
		
		@locations = apply_scopes(@permit.locations).published().includes(:city).includes(:permit).includes(:assets).page(params[:page]).per(12)
		
		@terms = TaxonomyTerm.current_entity_terms(Location, @locations.except(:limit).except(:order).select("locations.id").all)
		
		
		respond_with @locations
	end
	
	private
	def has_views
		case action_name
			when "show"
				[:quick]
		end
	end

end
