$(document).ready ->
	$('.locations.show .gallery-container .gallery-inner').thumbScroll
		thumb_el: '#thumb-scroller'
		
	$('#location-scroll-btn').on 'click', (e)->
		e.preventDefault()
		$('#thumb-next').trigger('click')
		
	$('#location-info-tabs a').on 'click', (e)->
		e.preventDefault()
		$(this).tab('show')
		
	$('a#location-scroll-back-btn').on "click", (e)->
		e.preventDefault()
		history.back()
		return false