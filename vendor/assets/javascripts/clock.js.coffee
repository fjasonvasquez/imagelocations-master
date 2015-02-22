$ = jQuery

timeZoneOffset = (offset)->
	now = new Date()
	now_utc = new Date(now.getUTCFullYear(), now.getUTCMonth(), now.getUTCDate(),	now.getUTCHours(), now.getUTCMinutes(), now.getUTCSeconds())
	return new Date(now_utc.getTime() + offset)
	
formatTimeString = (date)->
	hours = date.getHours()
	minutes = date.getMinutes()
	ampm = if hours >= 12 then 'pm' else 'am'
	hours = hours % 12
	hours = if hours then hours else 12
	minutes = if minutes < 10 then '0'+ minutes else minutes
	strTime = hours + ':' + minutes + ' ' + ampm
	return strTime
	
Clock = (el)->
	$t = $(el)
	utc_offset = $t.data("utc-offset") * 1000
	
	setTime = ()->
		$t.text(formatTimeString(timeZoneOffset(utc_offset)))
		
	setTime()
	
	setInterval setTime, 1000
	
$.fn.clock = () ->	
	@each ->
		$this = $(this)
		data = $this.data('Clock')
		if (!data) 
			$this.data('clock', (data = new Clock(this)))
		