class WeddingestatesLocationApplicationsController < LocationApplicationsController
	
	def create
	
		_errors_to_track = [:images, :email, :name, :city, :state]
		
		@location_application = LocationApplication.new(params[:location_application])
		
		error_count = 0
		
		if !@location_application.valid?
			@location_application.errors.each do |e|
				error_count += 1 if _errors_to_track.include? e
			end
		end
		
		
		respond_to do |format|
		  if error_count.zero? && ApplicationMailer.application_email(@location_application).deliver
		    format.js { render action: "success" }
		  else
		     format.js { render action: "new" }
		  end
		end
	end

end
