$(document).ready ->
	
	#if(!$(body).hasClass('categories'))
	#	return
	
	$('#exclusive-locations-thumbs .carousel').carousel({
			interval: 400,
			pause: "true"
	}).carousel('pause')
		
	
	$('body').on 'mouseenter', '#exclusive-locations-thumbs .carousel', ()->
		$carousel = $(this)
		$carousel.carousel('cycle')
		
		
	$('body').on 'mouseleave', '#exclusive-locations-thumbs .carousel', ()->
		$carousel = $(this)
		
		$carousel.one "slid", ()->
			$(this).carousel('pause')
		
		
		
		
	$('.publications.show .gallery-container .gallery-inner').thumbScroll({
		isActive: ($el,a_count,c_width)->
			 
			 $el.position().left >= 0 && $el.position().left + $el.width() <= c_width
	})

	
	$('body').data("spy","scroll")
	
	$('.row-header').affix({
		offset: {
			top: (e)->
				return $('#content').offset().top
			bottom: (e)->
				
		}	
	})
	$_pag = $('#paginator-container')
	$_main = $("#location-rows-container")
	$_pag.affix({
		offset:
			#top: null
			bottom: ()->
				
				_top = $_main.offset().top
				_doc = $(document).height()
				_offset = _doc - (_top + $_main.height())
				
				if(_doc <= $(window).height())
					_offset = _doc
					
				return _offset
	})
	
	$('#category-list').scrollPage({
		paginator: '#paginator',
		filter: '#filter',
		beforeLoad: (e)->
			$loader = $('#category-list-loader')
			$loader.appendTo($loader.parent()).removeClass('hide')
			#$loader.removeClass('hide')
		afterLoad: (e)->
			$('#category-list-loader').addClass('hide')
	})
	
	# $('#location-rows').scrollPage({
# 		paginator: '#paginator',
# 		onPaginationClick: (e)->
# 			$('#paginator-container').trigger("scroll.affix")
# 		beforeLoad: (e)->
# 			$loader = $('#location-rows-loader')
# 			#$loader.appendTo($loader.parent()).removeClass('hide')
# 			$loader.removeClass('hide')
# 		afterLoad: (e)->
# 			$('#location-rows-loader').addClass('hide')
# 	})
	
	
	$categoryNameList = $('#category-name-list')
	if($categoryNameList.length > 0)
		$parentViewport = $('.row-main');
		$trigger = $('#category-name-list-wrap')
		
		$parentViewport.css({
			minHeight: $categoryNameList.height()
		})
		
		$catThumbs = $('#category-thumbs')
		
		setCatMinHeight = (e)->	
			_top = $catThumbs.offset().top
			_doc = $(document).height()
			_offset = _doc - (_top + $catThumbs.height())
				
			if(_doc <= $(window).height())
				_offset = _doc
			
			_minHeight = $(window).height() - _offset
			
			_minHeight = if $categoryNameList.height() < _minHeight then $categoryNameList.height() else _minHeight
			
			$catThumbs.css({
				minHeight: _minHeight
			})
		
		#$(window).on "resize",setCatMinHeight
		
		#setCatMinHeight()
			
		$contentSections = $('#content .meat > div')
		
		$listLinks = $('#content .list h2 a')
		
		lastActiveLinkId = false
		
		$(document).on 'scroll resize mousewheel DOMMouseScroll ajax:complete',(e)->
			scrollTop = $(this).scrollTop()
			parentTop = $trigger.offset().top
			categoryHeight = $categoryNameList.height()
			parentHeight = $parentViewport.height()
			fixed = ((parentTop - scrollTop) <= 0) && parentHeight > categoryHeight
			
			bottomFixed = (categoryHeight + (scrollTop - (parentHeight + parentTop))) >= 0

			if bottomFixed
				fixed = false

			$categoryNameList.toggleClass('affix',fixed).toggleClass('affix-bottom',bottomFixed);
			
			$active = false
			$contentSections.each (i)->
				$t = $(this)

				
				if($active)
					return
				
				if(($t.offset().top - scrollTop) >= 0 || (i + 1) == $contentSections.length)
					$active = $t
			
			
			
			if(lastActiveLinkId != $active[0].id)
				$listLinks.removeClass('active')
				filterString = '[data-target=#' + $active[0].id + ']'
				$listLinks.filter(filterString).addClass('active')
					
			lastActiveLinkId = $active[0].id
				
				
			