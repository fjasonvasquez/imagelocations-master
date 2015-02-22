class ApplicationMailer < ActionMailer::Base
  default from: "application@imagelocations.com"
  
  
  
  def application_email(application)
  	@application = application
  	@images = []
  	
  	
  	@application.location_application_images.each_with_index do |image|
  		attachments.inline[image.source.filename] = File.read(image.source.file.file)
  		@images << image.source.filename
  	end
  	
  	mail(:subject => "#{@application.site.name} Location Application",
  		:to => Rails.configuration.contacts[:applications],
  		:reply_to => @application.email ) do |format|
  		#format.text
  		format.html
	end
  end
  
  private
  
  def default_url_options(options = {})
		{:host =>  Site.current.host }
  end
end
