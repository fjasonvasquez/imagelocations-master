class LocationApplicationsController < ApplicationController
	
	before_filter :parse_params, :only => [:create]
	
	def new
		@location_application = LocationApplication.new()
		@location_application.full_validation = true
	end
	
	
	def create
		
		_ap_key = :location_application
		_ap_image_key = :location_application_images_attributes
		
		_min_images = 0
		_max_images = 8
		
		params[_ap_key][_ap_image_key].keys.each_with_index do |key, index|
			
			param = params[_ap_key][_ap_image_key][key]
			
			if (param[:source_cache] == "" && param[:source].nil? && (index + 1) > _min_images ) || (index + 1) > _max_images
				params[_ap_key][_ap_image_key].delete(key)
			end
		
		end unless params[:location_application][:location_application_images_attributes].nil?
	
		@location_application = LocationApplication.new(params[:location_application])
		@location_application.full_validation = true
		@location_application.ip = request.remote_ip
		
		@location_application.user = current_user if user_signed_in?
				
		respond_to do |format|
		  if @location_application.save_with_captcha
		  	ApplicationMailer.application_email(@location_application).deliver
		  	format.html { redirect_to root_url, notice: 'Your application was received.' }
		    format.js { render action: "success" }
		  else

		  	format.html { render action: "new" }
		    format.js { render action: "new" }
		  end
		end
	end
	
	private
	
	def parse_params
		
		[:usage,:exclusive, :listing].each do |k|
			params[:location_application][k].delete_if { |param| param.blank? } unless params[:location_application][k].nil?
		
		end
	end
end
