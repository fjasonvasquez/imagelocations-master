$ = jQuery

weatherTemplate = (data)->
	return data["temperature"] + "&deg;&nbsp;" + data["summary"] + "&nbsp;" + "<i class='icon-weather icon-" + data["weather_icon"] + "'></i>"
	
expireDate = ()->
	now = new Date()
	now.setMinutes( now.getMinutes() + 10 )
	return now
	
Weather = (el)->
	$t = $(el)
	
	region = $t.data("region")
	$weatherStatus = $t.find('.current-region-weather')
	
	$t.on "weather",(e,data)->
		$weatherStatus.html(data)
	
	getData = ()->
		data = getCookieData()
		
		unless data
			$.ajax({
				dataType: "json"
				url: $t.data("source")
				success: (data)->
					setCookieData(data)
					$t.trigger("weather",getCookieData(data))
			})
		else
			$t.trigger("weather",data)
			
	getCookieData = ()->
		data = $.cookie('weather' + region)
		return data
		
	setCookieData = (data)->
		$.cookie('weather' + region, weatherTemplate(data), { expires: expireDate(), path: '/' })
	
	getData()
	
$.fn.weather = () ->	
	@each ->
		$this = $(this)
		data = $this.data('Weather')
		if (!data) 
			$this.data('weather', (data = new Weather(this)))
		