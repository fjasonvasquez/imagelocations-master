String.prototype.toUnderscore = ()->
	return this.replace /([A-Z])/g, ($1)->
		return "_"+$1.toLowerCase()

$ = jQuery

parseTemplate = (id,template)->
		time = new Date().getTime()
		regexp = new RegExp(id, "g")
		return template.replace(regexp, time)
	
allTerms = (string)->
	return  (s.trim() for s in string.split(","))
	
lastTerm = (string)->
	terms = allTerms(string)
	last = terms.pop()
	return last.trim()
	
existingTerms = (string)->
	terms = allTerms(string)
	terms.pop()
	return terms

KeywordField = (el)->
	$t = $(el)
	$input = $t.find('.keyword-taxonomy-field-values')
	
	$existing = ()->
		return $t.find(":input").not($input)
	
	id = $t.data('id')
	taxonomy_id = $t.data('taxonomy')
	template = $t.data('template')
	new_template = ()->
		return $(parseTemplate(id,template))
	
	processInputs = ()->
		values = allTerms($input.val())
		$labels = $t.find(":input[name*=name]")
		$labels.parent().addClass('remove')
		for value in values
			continue if value.length < 3
			$old = $labels.filter (index)->
				return $(this).val().toLowerCase() == value.toLowerCase()
			if $old.length > 0
				$old.parent().removeClass('remove').find(":input[name*=enable]").val("1")
			else
				$new = new_template()
				$new.find(":input[name*=name]").val(value)
				$t.prepend($new)
		
		$t.find(".remove").each (e)->
			$field = $(this)
			if parseInt($field.find(":input[name*=id]:first").val()) > 0
				$field.find(":input[name*=enable]").val("")
			else
				$field.remove()
		
		
	
	$input.change (e)->
		processInputs()
	
	
	$input.attr("autocomplete","off").typeahead
		matcher: (item)->
			return ~item.toLowerCase().indexOf(lastTerm(this.query).toLowerCase())	
		highlighter: (item)->
			query = this.query.replace(/[\-\[\]{}()*+?.,\\\^$|#\s]/g, '\\$&')
			#console.log query
			return item.replace new RegExp('(' + query + ')', 'ig') , ($1, match)-> 
				return '<strong>' + match + '</strong>'
		updater: (item)->
			value = existingTerms(this.$element.val())
			value.push item
			return value.join(", ")
		source: (query, process) ->
			query = lastTerm(query)
			if query.length < this.options.minLength
				return
			
			t = this
			t.labels = []
			t.mapped = {}
			data = {
				search: lastTerm(query)
				by_taxonomy: taxonomy_id
			}

			return $.ajax
				dataType: "json"
				url: '/admin/taxonomy_terms.json'
				data: data
				success: (data) ->
					for k,item of data
						t.mapped[item.taxonomy_term.label] = item
						t.labels.push(item.taxonomy_term.label)
					return process(t.labels)

$.fn.keywordField = () ->	
	@each ->
		$this = $(this)
		data = $this.data('keywordField')
		if (!data) 
			$this.data('modal', (data = new KeywordField(this)))
		