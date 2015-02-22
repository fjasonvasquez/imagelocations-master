//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require bootstrap-modal
//= require bootstrap-modalmanager
//= require jquery.easing-1.3
//= require jquery.mousewheel
//= require jquery.scrollwindow
//= require fancySelect
//= require jquery.superslides
//= require jquery.imageloader.js
//= require jquery.lazyload.js
//= require thumb_scroll
//= require flash_messages
//= require_tree .


fullWidth = ($el)->
	h_h = $("#header").outerHeight()
	f_h = $("#footer").outerHeight()
	w_h = $( window ).height()
	h = w_h - (h_h + f_h)
	o_h = $el.children().outerHeight()
	if h < o_h
		h = o_h
	
	$el.height(h)
		

openPublicPopup = (link)->
	$('body').addClass('no-scroll')
	#$(window).trigger()
	
	
	unless $('#public-private-popup-image').data('superslides')
		
		$('#public-private-popup-image').superslides({
			animation: "fade"
			pagination: false
			inherit_width_from: $('#public-private-popup')
			inherit_height_from: $('#public-private-popup')
		})
	
	$('#public-private-popup').addClass('in')
	$('#main').addClass('hide')
	$('#public-popup-link').one 'click', (e)->
		window.location = link
		
	$('#private-popup-link').one 'click', (e)->
		window.location = link + "?private=1"
	

$(document).ready ->
	#$('select.fancyselect').fancySelect()
	

	
	$('#location-application-modal-toggle').on "click", (e)->
		e.preventDefault()
		$('#location-application-modal').modal({
			show: true
			backdrop: false
		})
	
	#console.log(bgSlides)
	if !$('body').hasClass('user-is-subscriber')
		$('#regions a').on 'click', (e)->
			e.preventDefault()
			href = $(this).attr('href')
			openPublicPopup(href)
		
	
	$(".full-height").each (e)->
		$t = $(this)
		fullWidth($t)
		$(window).on "resize", ()->
			fullWidth($t)
	
	$(".collapse").each (e)->
		$t = $(this)
		$t.find(".close").on "click", (e)->
			$("[data-target=#" + $t[0].id + "]").trigger( "click" )
	
	$.scrollWindow()
	
	
	play = if $('#slides .slides-container').children().length > 1 then 3000 else 0
	
	$inherited = if $('body').hasClass('has-scroll-container') then $('#bg-slides') else $('#main')
	
	
	$('#slides').superslides({
		play: play
		animation: "fade"
		pagination: true
		inherit_width_from: $inherited
		inherit_height_from: $inherited
	})
	

$(document).ready ->
	

	onLazyLoad = (elements_left, settings)->
		$(this).closest(".lazy-container").trigger("scroll")
	
	setLazyImages = ()->
		$imgs = $("img.lazy")
		$imgs.removeClass("lazy")
		
		$imgs.each ()->
			$i = $(this)
			src = $i.data('src')
			$i[0].src = src
		
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