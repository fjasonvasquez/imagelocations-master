$(document).ready ->

	
	$(document).on "click","[data-target=_blank]", (e)->
		$(this).attr("target","_blank")
	
	$(".clock").clock();
	
	
	$(".weather-bar").weather();
	
	$('a.back-link').on "click", (e)->
		e.preventDefault()
		history.back()
		return false
	
	$(document).on 'click',"[data-submit-form]",(e)->
		$($(this).data('submit-form')).trigger("submit.rails")

	$('.modal').on 'shown', ->
    	$(this).find('input:visible:first').focus().end().find('form').enableClientSideValidations()
    

	#Scroller
	$('.scroll-to').each ()->
		$t = $(this)
		
		tClass = ()->
			$target = $($t.data('target'))
			
			return $target.offset().top <= $(document).scrollTop()
			
		$(document).on "scroll", (e)->
			$t.toggleClass "hide", tClass()
		
	$(document).on 'click','[data-scroll-to]',(e)->
		e.preventDefault()
		$target = $($(this).data('target'))
		
		
		$("html, body").animate({ 
				scrollTop: $target.offset().top
			}
		)
		
	#dont submit if nothing is entered
	$('#quick-search').on "submit", (e)->
		if $(this).find('.search-query').val() == ""
			e.preventDefault()
			return false
		return true
	
	
	#Searchbar
	$('input.search-query').on 'focus',()->
		$(this).next().addClass('hide');
		
		
	$('input.search-query').on 'blur',()->
		$(this).next().toggleClass('hide', $(this).val() != "")

	
	if($('input.search-query').val() != "")
		$('input.search-query').next().addClass('hide')
	
	
	ajaxSearchTimeout = false
	ajaxXhr = false
	ajaxQueryResults = {}
	
	ajaxResultFill = (count)->
		$span = $('.input-results').find('span')
		if(count < 1)
			$span.text($span.data("default-text"))
		else
			$span.text(count + " " + $span.data("append-text"))
		
	
	$('input.search-query').on "keypress", (e)->
		if e.which == 13
			console.log(e)
	
	$('input.search-query').on "keyup", (e)->	
		$t = $(this)
		$resultsCounter = $('.input-results')
		$form = $t.closest('form')
		query = $form.serialize()
		
		
			
		val = $.trim($t.val())
		val = val.replace(/^[,\s]+|[,\s]+$/g, '').replace(/,[,\s]*,/g, ',')
		
		if(ajaxXhr && ajaxXhr.readystate != 4)
			ajaxXhr.abort()
		
		if val.length < 2
			$resultsCounter.find('.icon-spinner').addClass('hide')
			return
		
		if ajaxQueryResults[val]
			$resultsCounter.find('.icon-spinner').addClass('hide')
			ajaxResultFill(ajaxQueryResults[val])
			return true
		
		$resultsCounter.find('span').empty()

		ajaxXhr = $.ajax({	
				url: $form.attr('action') + ".json"
				data: query
				beforeSend: ()->
					$resultsCounter.find('.icon-spinner').removeClass('hide')
				success: (data)->
					result = data._results.total_count
					ajaxQueryResults[val] = result;
					ajaxResultFill(result)
				complete: ()->
					$resultsCounter.find('.icon-spinner').addClass('hide')
				error: (e,v)->
					$resultsCounter.find('span').empty()
				dataType: 'json'
		})
	
	if $("body").hasClass('home')
	
		$carousel = $('.home.index #body-content .carousel')
		$carousel.carousel({
			interval: 5000
		})
		
		$('.home.index .container-tear .carousel').carousel({
			interval: 5000
		})
		
		$carousel.on "slid",()->
			$t = $(this)
			name = $t.find(".active").data("name")
			$t.find('.name').html(name)
	
		$('.carousel.tear .item').hover(
			()->
				$(this).find('.content-info').fadeIn()
			()->
				$(this).find('.content-info').stop().fadeOut()
		)
	
		sliderLoaded = (args)->
			args.currentSlideObject.addClass('active');
		
		$sliderBullets = $('.spotlight-slider-indicators li');
		
		sliderChange = (args)->
			args.sliderObject.find('.slide').removeClass('active');
			args.currentSlideObject.addClass('active');
			$('.spotlight-controls .name').html(args.currentSlideObject.data('name'))
			$('.spotlight-controls a.link').attr('href', args.currentSlideObject.attr('href'));
			$sliderBullets.removeClass('active').eq(args.currentSlideNumber - 1).addClass('active')
		
		$('.spotlight-slider-wrapper').iosSlider({
			autoSlide: true
			autoSlideTimer: 8000
			snapToChildren: true
			snapSlideCenter: false
			scrollbar: false
			leftOffset: 0
			infiniteSlider: true
			responsiveSlideContainer: false
			responsiveHeightSlideContainer: 767
			responsiveHeightSlideContainerRatio: .8
			desktopClickDrag: true
			onSliderLoaded: sliderLoaded
			onSlideChange: sliderChange
			navNextSelector: $('.container-spotlight .next-slide')
			navPrevSelector: $('.container-spotlight .prev-slide')
			navSlideSelector: $sliderBullets
		});