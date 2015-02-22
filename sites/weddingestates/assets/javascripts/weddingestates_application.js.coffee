getDoc = (frame)->
	doc = null
	try
		if (frame.contentWindow)
			doc = frame.contentWindow.document
	catch err
		doc = null
	
	if (doc)
		return doc
		
	try
		doc = frame.contentDocument ? frame.document
	catch err
		doc = frame.document
	
	return doc



$(document).ready ->
	$(document).on 'submit', '#location_application_form', (e)->
		
		$f = $(this)
		
		$f.find("button").button("loading")
		
		e.preventDefault()
		formURL = $f.attr('action')
		
		if(window.FormData != undefined)
			
			formData = new FormData(this)
			
			$.ajax({
				url: formURL
				type: 'POST'
				data:  formData
				mimeType:"multipart/form-data"
				contentType: false
				cache: false
				processData:false
				success: (data, textStatus, jqXHR)->
					eval(data)
					
				error: (jqXHR, textStatus, errorThrown)->
					return
				
				beforeSend: ()->
					$('#location_application_form').addClass('loading')
			})
			return false
			
		else
			iframeId = 'unique' + (new Date().getTime())
			iframe = $('<iframe src="javascript:false;" name="'+iframeId+'" />')
			iframe.hide()
			$f.attr('target',iframeId)
			
			iframe.load (e)->
				doc = getDoc(iframe[0])
				docRoot = doc.body ? doc.documentElement
				data = docRoot.innerHTML
				console.log(doc)
			
			iframe.appendTo('body')
		
		