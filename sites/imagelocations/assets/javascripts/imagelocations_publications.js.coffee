$(document).ready ->
	
	$carousels = $('.publications.index ul.publications .carousel').filter (i)->
		return $(this).find('.item').length > 1
	
	if($carousels.length > 0)

		$carousels.hover(
			(e)->
				$carousel = $(this)
				$carousel.carousel({
					interval: 400,
					pause: "false"
				})
				#$carousel.carousel('cycle')
			(e)->
				$carousel = $(this)
				#$carousel.carousel({
				#	interval: 0
				#})
				#$carousel.carousel('pause')
				#$carousel.carousel(0)
				$carousel.carousel('pause')
		)
	
	
	$('.publications.show .gallery-container .gallery-inner').thumbScroll({
		isActive: ($el,a_count,c_width)->
			 
			 $el.position().left >= 0 && $el.position().left + $el.width() <= c_width
	})
