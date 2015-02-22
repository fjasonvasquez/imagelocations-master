$(document).ready ->
	sortableHelper = (e, tr)->
		$originals = tr.children()
		$helper = tr.clone()
		$helper.children().each (index)->
			$(this).width($originals.eq(index).width())
		return $helper
		
	calculateRelatedEntitiesPriorities = (e)->
		
		$(e).find('tr').each (index)->
			console.log($(this).find(':input[name*=priority]'))
			$(this).find(':input[name*=priority]').val(index)
		
	$("table.table-ordered tbody").sortable
		helper: sortableHelper
		handle: ".reorder"
		start: (event, ui)->
			
		stop: (event, ui)->
			calculateRelatedEntitiesPriorities(this)
		update: ->
			$.post($(this).closest('form').attr('action'), $(this).closest('form').serialize())
			
		