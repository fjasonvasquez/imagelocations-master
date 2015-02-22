$(document).ready ->
	
	$seriesName = $('#location_series_name')
	#$seriesId = $('#location_series_attributes_id')
	$seriesNumber = $('#location_series_number')
	
	locationId = $seriesName.closest('form').data('entity-id') || 0
	#currentSite = 
	
	
	permitFormat = (permit)->
		text = ""
		logo = $(permit.element).data("logo")
		#logo = permit.element.data("logo")
		if logo
			text += "<img class='option-img' src='" + logo + "'/>&nbsp;"
		return text + permit.text
	
	$(".permit-select").select2
		formatResult: permitFormat
		formatSelection: permitFormat
		escapeMarkup: (m)->
			return m
	
	$(".category-select").select2
		width: "resolve"
		allowClear: true
		
	$seriesNumber.on "change", (e)->
		invalid = $(this).data('invalid-numbers')
		value = parseInt $(this).val()
		$(this).closest('.control-group').toggleClass('error', invalid.indexOf(value) >= 0 )
	
	$seriesName.on "keyup", (e)->
		$seriesNumber.data('invalid-numbers',[]).closest('.control-group').removeClass('error')
		
	seriesXhr = false
	
	$seriesName.attr("autocomplete","off").typeahead
		updater: (item)->
			series = this.mapped[item]
			series_number = series.next_series_number
			invalid_numbers = series.series_numbers
			
			for k,location of series.locations
				if location.id == locationId
					series_number = location.series_number
					invalid_numbers.splice(invalid_numbers.indexOf(location.series_number), 1);
			
			
			$seriesNumber.data('invalid-numbers',invalid_numbers)
			#if series.locations[loc_array.length-1]
			#console.log invalid_numbers
			#next_number = 
			
			$seriesName.one 'change', (e)->
				#console.log 'test'
			
			$seriesNumber.val(series_number)
			#$seriesId.val(series.id)
			
			return item
		source: (query, process) ->
			t = this
			t.labels = []
			t.mapped = {}
			#console.log query
			data = {
				site: 0,
				search: query
			}
			if(seriesXhr && seriesXhr.readystate != 4)
				seriesXhr.abort()
			seriesXhr = $.ajax
				dataType: "json"
				url: '/admin/series.json'
				data: data
				success: (data) ->
					console.log(data)
					for k,item of data
						t.mapped[item['series'].name] = item['series']
						t.labels.push(item['series'].name)
					return process(t.labels)
			return seriesXhr
	
	
	$cityInput = $('.location_city_name :input')
	$stateInput = $('.location_city_state_name :input')
	$countrySelect = $('.location_city_state_country_alpha2 :input')
	
	
	$countrySelect.select2
		placeholder: "Select a Country"
		
	setCountry = (value)->
		$countrySelect.val(value).trigger("change")
	
	setState = (value)->
		$stateInput.val(value)
	
	citiesXhr = false
	
	$cityInput.attr("autocomplete","off").typeahead
		items: 20
		updater: (item)->
			result = this.mapped[item]
			setCountry(result.city.state.country_alpha2)
			setState(result.city.state.name)
			return result.city.name
		source: (query, process) ->
			t = this
			t.labels = []
			t.mapped = {}
			
			data = {
				search: query
				
			}
			if(citiesXhr && citiesXhr.readystate != 4)
				citiesXhr.abort()
			
			citiesXhr = $.ajax
				dataType: "json"
				url: '/admin/cities.json'
				data: data
				success: (data) ->
					
					for k,item of data
						console.log(item)
						t.mapped[item.city.full_name] = item
						t.labels.push(item.city.full_name)
					return process(t.labels)
			return citiesXhr