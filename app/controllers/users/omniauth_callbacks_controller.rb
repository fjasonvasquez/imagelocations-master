class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
	def google_oauth2
      # You need to implement the method below in your model (e.g. app/models/user.rb)
      #@user = User.find_for_google_oauth2(request.env["omniauth.auth"], current_user)
	  #ap client
	  
	  auth = request.env["omniauth.auth"] 
	  params = request.env["omniauth.params"]
	  
	  if user_signed_in?
		  @auth = current_user.authentications.where(:provider => auth['provider']).first_or_create
		  
		  @auth.uid = auth['uid']
		  @auth.access_token = auth['credentials']['refresh_token']
		  @auth.save!
	  end
	  
	  redirect_to request.env["omniauth.origin"]
	  

      #if @user.persisted?
      #  flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Google"
      #  sign_in_and_redirect @user, :event => :authentication
      #else
      #  session["devise.google_data"] = request.env["omniauth.auth"]
      #  redirect_to new_user_registration_url
      #end
  end
end