$ = jQuery

parseTemplate = (id,template)->
		time = new Date().getTime()
		regexp = new RegExp(id, "g")
		return template.replace(regexp, time)
	
parseTag = (tag)->
	if !tag.id
		tag.id = tag.text
	return tag

keywordSelect2 = (el)->
	$t = $(el)
	$parent = $t.parent()
	taxonomy = $t.data('taxonomy')
	template_id =  $t.data('id')
	template = $t.data('template')
	tags = $t.data('terms') || []
	
	tags = (parseTag tag for tag in tags)
	
	
	$t.select2
		width: "100%"
		tags: tags
		tokenSeparators: [","]
		minimumInputLength: 2
		maximumSelectionSize: 0
		initSelection: (element, callback)->
			callback(tags)
		createSearchChoice: (term, data) ->
			s = $(data).filter ()->
					return this.text.localeCompare(term) == 0
			
			if s.length == 0
				return {
					text: term
					id: term
				}
		multiple: true
		ajax:
			url: "/admin/taxonomy_terms.json"
			dataType: 'json'
			quietMillis: 100
			data: (term, page)->
				
				return {
					search: term
					by_taxonomy: taxonomy
				}
			results: (data, page)->
				
				return {
					results: ({text: d.taxonomy_term.name, id: d.taxonomy_term.id} for d in data)
				}
	
	$t.on('change',(e)->
		console.log('changed')
		if e.added
			$input = getInput(e.added)
			if $input
				$input.val(1);
			
		else if e.removed
			$input = getInput(e.removed)
			if $input
				$input.val(0);
	)
	
	getInput = (term)->
		$i = $parent.find(":input[name*=taxonomy_term_id][value=" + term.id + "]")
		$el = $i.next(":input[name*=enable]")
		if($el.length > 0)
			return $el
		
		$i = $(parseTemplate(template_id,template))
		
		$i.find(":input[name*=taxonomy_term_id]").val(term.id)
		$i.find(":input[name*=name]").val(term.text)
		
		$t.parent().append($i)
		$el = $i.find(":input[name*=enable]")
		
		return $el

$.fn.keywordSelect2 = () ->	
	@each ->
		$this = $(this)
		data = $this.data('keywordSelect2')
		if (!data) 
			$this.data('keywordSelect2', (data = new keywordSelect2(this)))
		