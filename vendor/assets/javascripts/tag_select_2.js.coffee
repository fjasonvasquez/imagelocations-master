$ = jQuery

tagSelect2 = (el)->
	$t = $(el)
	$parent = $t.parent()
	
	$t.select2
		width: "100%"
		
	$t.on('change',(e)->
		if e.added
			$input = getInput(e.added.id)
			if $input
				$input.val(1);
			
		else if e.removed
			$input = getInput(e.removed.id)
			if $input
				$input.val(0);
	)
	
	getInput = (id)->
		$i = $parent.find(":input[name*=taxonomy_term_id][value=" + id + "]")
		$el = $i.next(":input[name*=enable]")
		if($el.length > 0)
			return $el
			
		return false
		
	
$.fn.tagSelect2 = () ->	
	@each ->
		$this = $(this)
		data = $this.data('tagSelect2')
		if (!data) 
			$this.data('tagSelect2', (data = new tagSelect2(this)))
		