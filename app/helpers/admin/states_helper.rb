module Admin::StatesHelper
	def states_countries_filter_options
		{}.tap { |o| State.countries.each {|state| o.merge!({state.country_alpha2 => state.country.name}) } }
	end

end
