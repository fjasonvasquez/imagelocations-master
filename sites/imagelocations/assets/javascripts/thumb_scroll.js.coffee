$ = jQuery

ThumbScroll = (el,opts)->
	t = this
	options = $.extend({
		thumb_el: false,
		active_max: 1,
		isActive: ($el,a_count,c_width)->
			 (!this.active_max || (this.active_max > a_count)) && (($el.width() + $el.position().left) / c_width > .5)
			 
	},opts)
	
	$scroll_el = $(el)
	
	if options.thumb_el
		$t = $(options.thumb_el)
		$t_scroll = $t.find('ul')
		
		$t_scroll.on 'click', 'li', (e)->
			e.preventDefault()
			t.goTo($(this).data('id'))
	
	$nav = $scroll_el.parent().find('.thumb-scroll-nav')
	$nav.attr('unselectable', 'on').css('user-select', 'none').on('selectstart', false)
	

	setDimensions = ()->
		t.c_width = $scroll_el.width()
		t.f_width = $scroll_el[0].scrollWidth
		t.s_left = $scroll_el.scrollLeft()
		
		if options.thumb_el
			t.tc_width = $t.width()
			t.tf_width = $t_scroll.width()
	
		
	
	setDimensions()
	
	$(document).on 'resize', ()->
		setDimensions()
	
	$scroll_el.on 'scroll' , (e)->
		t.scroll()
	
	t.goTo = (id)->
		$target = if(id instanceof jQuery) then id else $scroll_el.find('[data-id=' + id + ']')
		if $target.length > 0
			c_offset = Math.floor((t.c_width - $target.width())/2);
			$scroll_el.stop().animate({ scrollLeft: "+=" + ($target.position().left - c_offset) }, 600);
	
	t.scroll = ()->
		setDimensions()
		
		$children = $scroll_el.find('li')
		$active_child
		active_count = 0
		
		if t.s_left > t.f_width
			return
		
		i = 0
		
		for child in $children
			i++
			$child = $(child)
			inFrame = options.isActive($child,active_count,t.c_width)
			
			if t.s_left + t.c_width == t.f_width
				inFrame = i == $children.length
				
			if t.s_left == 0
				inFrame = i == 1
			
			$child.toggleClass('active', inFrame)
						
			if(inFrame)
				active_count++
				$active_child = $child
		
		if options.thumb_el
			$aThumb = $t.find('[data-id=' + $active_child.data('id') + ']')
			
			
			if !$aThumb.hasClass('active')
				$t_scroll.children('li').removeClass('active')
				$aThumb.addClass('active')
			
			c_offset = (((t.c_width - $active_child.width()) / 2) - $active_child.position().left) / t.c_width
			
			t_offset = -$aThumb.position().left + Math.floor((t.tc_width/2))
			
			t_offset -= c_offset * $aThumb.width()
			
			if t_offset + $t_scroll.width() < t.tc_width
				t_offset = -($t_scroll.width() - t.tc_width)
			
			if t_offset > 0 || t.tf_width <= t.tc_width
				t_offset = 0
			
			$t_scroll.stop(false,true).animate({
					left: t_offset
				},{
					duration: 300
			})

		
	$nav.on 'click', (e)->
		e.preventDefault()
		dir = -1
		if $(this).data('slide') == "next"
			dir = 1
		
		$active = $scroll_el.find('.active')
		
		
		if $active.length > 1
			if dir > 0
				$active = $active.last()
			else
				$active = $active.first()
		
		
		n_index = $active.index() + dir
		
		if n_index < 0
			n_index = 0
		
		$n_active = $scroll_el.find('li').eq(n_index)
		
		if $n_active.length > 0
			t.goTo($n_active)
	
	if $scroll_el.find('.active').length < 1
		$(window).on 'load',()->
			t.scroll()
	

		
				

	
$.fn.thumbScroll = (options) ->	
	@each ->
		$this = $(this)
		data = $this.data('ThumbScroll')
		if (!data) 
			$this.data('ThumbScroll', (data = new ThumbScroll(this,options)))