class SubscriptionMailer < ActionMailer::Base
	add_template_helper(SubscriptionsHelper)
  default from: "no-reply@imagelocations.com"

  def subscription_email(subscription)
  	@subscription = subscription
  	mail(:subject => "You're Subscription has been activated", :to => @subscription.user.email) do |format|
  		format.text
  		format.html
	end
  end
  
  def subscription_notification_email(subscription)
  	@subscription = subscription
  	mail(:subject => "A user has created a new subscription", :to => Rails.configuration.contacts[:subscriptions]) do |format|
  		format.text
  		format.html
	end
  end
  
  private
  
  def default_url_options(options = {})
		{:host =>  Site.current.host }
  end
end
