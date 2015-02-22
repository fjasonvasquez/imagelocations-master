class EntityMailer < ActionMailer::Base
  add_template_helper(CollectionsHelper)
  default from: "location@imagelocations.com"

  def collection_email(email,collection)
  	@email = email
  	@collection = collection
  	mail(:subject => email.subject, :to => email.recipient, :reply_to => email.sender) do |format|
  		format.text
  		format.html
	end
  end
  
  def location_email(email,location)
  	@email = email
  	@location = location
  	mail(:subject => email.subject, :to => email.recipient, :reply_to => email.sender) do |format|
  		format.text
  		format.html
	end
  end
  
  def location_download_email(email,location, version)
  	@email = email
  	@location = location
  	@version = version
  	
  	mail(:subject => email.subject, :to => email.recipient, :reply_to => email.sender) do |format|
  		format.text
  		format.html
	end
  end
  
  def category_email(email,category)
  	@email = email
  	@category = category
  	mail(:subject => email.subject, :to => email.recipient, :reply_to => email.sender) do |format|
  		format.text
  		format.html
	end
  end
  
  private
  
  def default_url_options(options = {})
		{:host =>  Site.current.host }
  end
end
