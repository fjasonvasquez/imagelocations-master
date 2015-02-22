class WeddingestatesCitiesController < CitiesController
	
	has_scope :is_not_private, :type => :boolean, :only => :show
	has_scope :is_private, :type => :boolean, :only => :show
	
	before_filter :process_private_param, :only => :show

	def show
		super
	
	end
	
	
	def process_private_param
		
		
		params[:is_not_private] = !user_is_subscribed? && params[:private].nil? if !user_is_subscribed? && params[:private].nil?
		
		params[:is_private] = true if !params[:private].nil?
		
	end

end