$ = jQuery

$.fn.fileUploadField = () ->
  @each ->
  	$this = $(this)
  	$form = $this.closest('form')
  	fileAttr = $this.data('file-attribute')
  	console.log(fileAttr)
  	$form.fileupload
  		fileInput: $this.find('input.file_uploader')
  		uploadTemplateId: fileAttr + '-upload-template'
  		downloadTemplateId: fileAttr + '-download-template'
  		filesContainer: '#' + fileAttr + '-files-container'
  		dataType: "script"
  		add: (e, data) ->
      		types = /(\.|\/)(gif|jpe?g|png)$/i
      		
      		file = data.files[0]
      		console.log file
      		if types.test(file.type) || types.test(file.name)
      			#data.context = $(tmpl(fileAttr + "-upload-template", file))
      			console.log data
      			#$form.append(data.context)
      			data.submit()
      		else
      			alert("#{file.name} is not a gif, jpeg, or png image file")
      	progress: (e, data) ->
      		if data.context
      			progress = parseInt(data.loaded / data.total * 100, 10)
      			data.context.find('.bar').css('width', progress + '%')