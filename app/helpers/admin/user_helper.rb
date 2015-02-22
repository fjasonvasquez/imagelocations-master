module Admin::UserHelper
	
	def format_user_date(date)
			
		unless date.nil? then date.to_date else "Never" end
	end
	
	def site_filter_select
		select_tag("by_site",options_for_select([["All" , "0" ]],
			:selected => params[:by_site]) + options_from_collection_for_select(Site.active.has_members.all,'id','name',params[:by_site]),
			{:include_blank => 'None'}
		)
  	end
  	
  	def user_role_filter_options  		
  		{}.tap { |o| Role.has_members.all.each.map {|role| o.merge!({role.id.to_s => role.label})} }
  	end
  	
  	def user_status_filter_options
  		{}.tap { |o| User::USER_STATUSES.each {|status| o.merge!({status => I18n.t(status)}) } }
  	end
  	
  	def role_filter_select
		select_tag("by_role", 
			options_from_collection_for_select(Role.has_members.all,'id','label',params[:by_role]),
			{:include_blank => 'None'}
		)
  	end
  	
  	
  	def role_filter_select
		select_tag("by_role", 
			options_from_collection_for_select(Role.has_members.all,'id','label',params[:by_role]),
			{:include_blank => 'None'}
		)
  	end
  	
  	def status_filter_select
		select_tag("by_status", 
			options_for_select(User::USER_STATUSES.collect {|p| [ I18n.t(p), p ] },
			:selected => params[:by_status]),
			{:include_blank => 'None'}
		)
  	end
  	
end
