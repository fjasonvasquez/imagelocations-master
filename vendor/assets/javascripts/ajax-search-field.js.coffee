$ = jQuery

AjaxSearchField = (el)->
	$t = $(el)
	base = $t.data("base")
	$form = $t.closest("form")
	
	$t.attr("autocomplete","off").typeahead
			
			updater: (item)->
				url = this.mapped[item]
				window.location = url
				return item
			source: (query, process) ->
				t = this
				t.labels = []
				t.mapped = {}
				#console.log query
				data = {
					search: query
					
				}
				return $.ajax
					dataType: "json"
					url: ""
					data: data
					success: (data) ->
						for k,item of data
							t.mapped[item[base].name] = item[base].url
							t.labels.push(item[base].name)
						return process(t.labels)
					
					
					
$.fn.ajaxSearchField = () ->	
	@each ->
		$this = $(this)
		data = $this.data('ajaxSearchField')
		if (!data) 
			$this.data('ajaxSearchField', (data = new AjaxSearchField(this)))
			
			
$(document).ready ->
	$("[data-type=search]").ajaxSearchField()