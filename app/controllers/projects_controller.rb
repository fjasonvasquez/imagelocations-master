class ProjectsController < ApplicationController
	
	has_scope :site
	#has_scope :region, :only => [:show]
	
	before_filter :validate_access, :only => [:index]
	
	#caches_action :show, :cache_path => Proc.new { |c| c.params.delete_if { |k,v| k.starts_with?('utm_') } }
	
	respond_to :html
	
	def index
		
		@projects = apply_scopes(Project).published().order("projects.name ASC")
	end
	
	def show
		@project = apply_scopes(Project).published().find_by_id_or_slug(params[:id]).first
		
		raise ActiveRecord::RecordNotFound if @project.nil?
				
		@project_related_entities = @project.current_published_related_entities().includes(:site_entitable).reorder("related_site_entities.priority ASC")
		
		
		
		@locations = [].tap do |o|
			@project_related_entities.each {|se| o << se.site_entitable }
		end
		
		respond_with(@project)
		
	end
	
	
	def auth
		access_code = current_site_setting(:client_access_code)
		
		unless params[:client_access_code].blank? || !access_code
			
			if params[:client_access_code] == access_code
				session[:client_access] = TRUE
				redirect_to projects_path
			else
				redirect_to projects_path, :flash => { :error => I18n.t("projects.client_access_error")}
			
			end
		end
	end
	
	private
	
	def validate_access
		render( :action => "auth") unless can_access
	end
	
	def can_access
		!session[:client_access].blank? || current_user
	end
	
	
	private
	
	def per_page
		case action_name
			when "index"
				12
			when "show"
				6
		end
	end
	
end
