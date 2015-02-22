$ = jQuery

parseTemplate = (id,template)->
	time = new Date().getTime()
	regexp = new RegExp(id, "g")
	return template.replace(regexp, time)

relatedEntitiesHelper = (e, tr)->
	$originals = tr.children()
	$helper = tr.clone()
	$helper.children().each (index)->
		$(this).width($originals.eq(index).width())
	return $helper
		
calculateRelatedEntitiesPriorities = (e)->
	
	$(e).find('tr').each (index)->
		#console.log($(this).find(':input[name*=priority]'))
		$(this).find(':input[name*=priority]').val(index)
	

relatedEntities = (el)->
	
	xHr = false
	
	toggleSearch = ()->
		return if($searchInput.data('limit') == 0)
		$searchInput.closest('tr').toggleClass 'hide', ($this.find(':input[name*=_destroy][value=0]').length >= $searchInput.data('limit'))
		
	$this = $(el)
	
	
	
	$searchInput = $this.find('input.related-entity-search-input')
	$searchAdd = $searchInput.next('a')
	$searchAdd.data('base_path',$searchAdd.attr("href").slice(0, - 1))
	$searchAdd.attr("href",$searchAdd.data("base_path")).button()
	
	$this.closest('form').on 'submit', (e)->
		_searchInputFocused = $searchInput.is(":focus")
		return !_searchInputFocused
	
	
	$similarContainer = $this.find('tbody')
	toggleSearch()
	
	$similarContainer.on "click", "button.related-entity-remove", ->
		$tr = $(this).closest('tr')
		
		if parseInt($tr.find('.entity-id').val()) > 0
			$tr.addClass('hide').find(':input[name*=_destroy]').val("1")
		else
			$tr.remove()
		toggleSearch()
		calculateRelatedEntitiesPriorities($similarContainer)
		
	$searchInput.on "keypress", (e)->
		keycode = if event.keyCode then event.keyCode else event.which
		if keycode != 13
			$searchAdd.addClass('disabled').data('site-entity',null)
		else
			$searchAdd.trigger('click')
			
		
	$searchAdd.on "click", (e)->
		$t = $(this)
		e.preventDefault()
		
		entity = $t.data('site-entity')
		
		if $t.hasClass('disabled')
			return false;
		
		$t.addClass('disabled')
		#$searchInput.val('')
		
		$existing = $similarContainer.find(":input[name*=related_site_entity_id][value=" + entity.id + "]")
		
		if $existing.length > 0
			$existing = $existing.closest('tr')
			$similarContainer.prepend $existing
			$existing.find('.related-entity-destroy').val("")
			$existing.show()
		else			
			
			$new_field = $(parseTemplate($t.data('id'),$t.data('template')))
			$new_field.find('.related-entity-name').text($t.data('site-entity').name)
			$new_field.find(":input[name*=related_site_entity_id]").val($t.data('site-entity').id)
			
			$similarContainer.prepend($new_field)
		
		toggleSearch()
		calculateRelatedEntitiesPriorities($similarContainer)
		
	
	$searchInput.attr("autocomplete","off").typeahead
		updater: (item)->
			data = this.mapped[item]
			$searchAdd.data('site-entity',data.site_entity)
			$searchAdd.removeClass('disabled')
			return item
		source: (query, process) ->
			t = this
			t.labels = []
			t.mapped = {}
			excludeIds = [t.$element.data('id')]
			
			$searchAdd.addClass('disabled').data('site-entity',null)
			
			$this.find(":input[name*=related_site_entity_id]").each ->
				
				unless $(this).closest('tr').hasClass('hide')
					excludeIds.push $(this).val()
						
			data = {
				excluding_ids: excludeIds
				site: t.$element.data('site')
				type: t.$element.data('type')
			}
			search_param = "search_by_" + t.$element.data('type').toLowerCase() + "_name"
			data[search_param] = query
			
			if(xHr && xHr.readystate != 4)
				xHr.abort()
			
			xHr = $.ajax
				dataType: "json"
				url: '/admin/site_entities.json'
				data: data
				beforeSend: ()->
					#$searchAdd.button('loading')
				complete: ()->
					
					#$searchAdd.button('reset')
				success: (data) ->
					for k,item of data
						t.mapped[item.site_entity.name] = item
						t.labels.push(item.site_entity.name)
					return process(t.labels)
			return xHr
	 
	$similarContainer.sortable
		helper: relatedEntitiesHelper
		handle: ".reorder"
		start: (event, ui)->
			ui.item.addClass('up')
		stop: (event, ui)->
			calculateRelatedEntitiesPriorities(this)
			ui.item.removeClass('up')
			
	
$.fn.relatedEntities = () ->	
	@each ->
		$this = $(this)
		data = $this.data('relatedEntities')
		if (!data) 
			$this.data('relatedEntities', (data = new relatedEntities(this)))
		