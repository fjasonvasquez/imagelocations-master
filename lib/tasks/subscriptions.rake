namespace :subscriptions do
	
	task :expire => :environment do
		
		now = DateTime.now
		
		Subscription.active().where(['expiration_date < ?', now]).find_each do |subscription|
			subscription.expire
			subscription.save
		end
		
	end
	
end