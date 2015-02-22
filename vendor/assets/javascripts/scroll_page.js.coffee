$ = jQuery

scrollPage = (el,options)->
	$t = $(el)
	that = this
	scrollXhr = false
	$pagination = if options.paginator then $(options.paginator) else false
	$filter = if options.filter then $(options.filter) else false
	
	pauseScroll = false
	
	$controls = []

    
	if $pagination then $controls.push(options.paginator)
	if $filter then $controls.push(options.filter)
	
	$controls = $($controls.join(', '))
	
	if options.beforeLoad && typeof options.beforeLoad == "function"
		$controls.on 'ajax:before','[data-remote=true]',(x,s)->
			options.beforeLoad.call(that,this)
	
	if options.afterLoad && typeof options.afterLoad == "function"
		$controls.on 'ajax:success','[data-remote=true]',(e,x,s)->
			options.afterLoad.call(that,this, x, s)
	
	if($filter)
		$filter.on 'ajax:beforeSend','[data-remote=true]', (e, xhr, settings)->
			pauseScroll = true
			$t.empty()
			true
			
	$controls.on 'ajax:beforeSend','[data-remote=true]',(e, xhr,s)->
		
		if(scrollXhr && scrollXhr.readyState != 4)
			scrollXhr.abort()
		
		scrollXhr = xhr
		return true
		
	$pagination.on 'click', '[data-remote=true]',(e)->
		$t.empty()
		if options.onPaginationClick && typeof options.onPaginationClick == "function"
			options.onPaginationClick.call(that,this)
		#$(document).trigger('scroll')
		true
	
	
	
	$(window).on 'scroll resize mousewheel DOMMouseScroll',(e)->
		clearTimeout(scrollTimeout)
		if(pauseScroll)
			return
		
		scrollTimeout = setTimeout(()->
		
			$next = getNextPageLink()
			
			containerHeight = $t.height()
			offsetTop = $t.offset().top
			scrollTop = $(window).scrollTop()
			windowHeight = if window.innerHeight then window.innerHeight else $(window).height()
			
			if($next && ((windowHeight + scrollTop) - (offsetTop + containerHeight) >= 0))
				$next.trigger('click.rails')
				$next.data('disable',1)
		,150)
		
	
	getNextPageLink = ()->
		$links = $pagination.find(".page")
		
		if($links.length < 1)
			return false
		
		return $links.filter((index)->
			return $links.eq(index - 1).hasClass('active') && (index - 1) >= 0 && !$links.eq(index).find('a').data('disable')
			).find('a')
			

	
	this.appendContent = (html)->
		$t.append(html)
		
	
	this.replaceFilter = (html)->
		$controls.one 'ajax:complete','[data-remote=true]',(x,s)->
			pauseScroll = false
			$filter.html(html)
	
	
	this.replacePagination = (html)->
		$controls.one 'ajax:complete','[data-remote=true]',(x,s)->
			$pagination.html(html)

	
	return this
		
$.fn.scrollPage = (options, args) ->	
	@each ->
		$this = $(this)
		data = $this.data('scrollPage')
		
		if (!data) 
			$this.data('scrollPage', (data = new scrollPage(this,options)))
		else if(typeof options == "string" && typeof data[options] == "function")
			data[options].call(data,args)
			
		return this