module LocationApplicationsHelper
	def init_location_application_images(application)
		_field_count = 8
		_fields = application.location_application_images
		
		while application.location_application_images.length < _field_count do
		
			application.location_application_images.build()
			#logger.debug _fields
		end
		_fields
		application.location_application_images
	end
end
