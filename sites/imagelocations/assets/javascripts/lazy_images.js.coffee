lazyByPriority = ()->
	$imgs = $("img.lazy")
	
	if $imgs.length > 0
		
		p_imgs = []
		for img in $imgs
			$i = $(img)
			priority = if $i.data('load-priority') != undefined then $i.data('load-priority') else 0
			
			if p_imgs[priority] == undefined
				p_imgs[priority] = []
				
			p_imgs[priority].push($i)
			
		if p_imgs.length > 0
			$imgs = $($.map(p_imgs[p_imgs.length - 1], (el)-> $.makeArray(el)))
			
			$($imgs).removeClass('lazy').imageloader({
				callback: lazyByPriority,
				timeout: 20000
			})
		
		


$(document).ready ->
	
	$.imageloader.queueInterval = 34
	
	onLazyLoad = (elements_left, settings)->
		$(this).closest(".lazy-container").trigger("scroll")
	
	
	
	
	setLazyImages = ()->
		
		lazyByPriority()
				
		$(".lazy-container").each ()->
			$c = $(this)
			$cont = if $c.data("target") then $($c.data("target")) else $c
			$c.find("img.lazy-scroll").removeClass("lazy-scroll").lazyload({
 				threshold: 200
 				container: $cont
 				event: "scroll moved"
 				load: onLazyLoad
 			})
 			$c.removeClass("lazy-container")


				
	setLazyImages()
	
	$(document).on 'ajax:complete', '[data-remote=true]', ()->
		setLazyImages()