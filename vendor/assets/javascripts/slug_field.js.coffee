$ = jQuery

removeError = ($el)->
	$el.removeClass('error')

addError = ($el)->
	$el.addClass('error')

SlugField = (el)->
	$t = $(el)
	
	$container = $t.closest('.control-group')
	
	params =
		excluding_ids: [$t.data('id')]
		type: $t.data('type')
		site: $t.data('site')
	
	xHr = false
	
	$t.on "change", ()->
		val = $t.val()
		checkSlug(val)
	
	$t.on "keyup", ()->
		val = $t.val()
		checkSlug(val)
	
	
	checkSlug = (slug)->
		
		if slug == ""
			removeError($container)
			return
		
		if(xHr && xHr.readystate != 4)
			xHr.abort()
		
		params["slug"] = slug
		
		xHr = $.ajax
			dataType: "json"
			url: "/admin/site_entities.json"
			data: params
			success: (data) ->
				if(data.length > 0)
					addError($container)
				else
					removeError($container)
			
			
$.fn.slugField = () ->	
	@each ->
		$this = $(this)
		data = $this.data('slugField')
		if (!data) 
			$this.data('slugField', (data = new SlugField(this)))
		