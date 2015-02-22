class UserMailer < ActionMailer::Base
  default from: "no-reply@imagelocations.com"

  def welcome_email(user)
  	@user = user
  	mail(:subject => "Welcome to #{Site.current.name}", :to => @user.email) do |format|
  		format.text
  		format.html
	end
  end
  
  private
  
  def default_url_options(options = {})
		{:host =>  Site.current.host }
  end
end
