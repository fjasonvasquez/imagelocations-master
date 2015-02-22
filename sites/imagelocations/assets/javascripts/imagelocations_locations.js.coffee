# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$(document).ready ->
	# 
# 	$sidebar = $('#location-sidebar')
# 	
# 	openLocationSidebar = ()->
# 		$sidebar.find('.close').removeClass('icon-plus').addClass('icon-minus')
# 		$('#location-container').removeClass('closed')
# 		$('.moodboard').data('MoodBoard').enableDrag()
# 	
# 	closeLocationSidebar = ()->
# 		$sidebar.find('.close').removeClass('icon-minus').addClass('icon-plus')
# 		$('#location-container').addClass('closed')
# 		$('.moodboard').data('MoodBoard').disableDrag()
	
	$('.locations.show a.permit-link, #permit-info .close').on "click",(e)->
		e.preventDefault()
		
		$('#permit-info').toggleClass('hide')
		
	$('#location-meta-toggle').disableSelection()
	# $(document).on 'click touch', '#location-meta-toggle.icon-plus', openLocationSidebar
# 		
# 	$(document).on 'click touch', '#location-meta-toggle.icon-minus', closeLocationSidebar
		
	
	$('#location-asset-list-wrapper').thumbScroll({
		thumb_el: '#thumb-scroller'
	})
	
	$('#collage-toggle , #collage-close, #location-collage-list-wrapper img').on 'click', (e)->
		e.preventDefault()
		$collage = $('#location-collage-list-wrapper')
		$collage.toggleClass('in')
		_open = $collage.hasClass('in')
		$('#collage-close').toggleClass('hide',!_open);
		$ct = $('#collage-toggle');
		if _open
			$ct.find('span').text($ct.data('close'));
		else
			$ct.find('span').text($ct.data('open'));

		
		
		
	
	window.onload = ()->
		$('.slider-container').lemmonSlider({
			loop: false
		})
		# if window.innerWidth < 772
# 			closeLocationSidebar()