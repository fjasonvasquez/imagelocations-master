# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
cancel_drop = (e)->
	e.stopPropagation()
	e.preventDefault()
	return false

image_field_status = ()->
	$t = $(this)
	$cg = $t.closest('.control-group')
	if($cg.data("filename"))
		$t.text($cg.data("filename")).removeClass("blank")
	else
		$t.text($cg.data("label"))

$filedropTarget = false


init_application = ()->
	
	$('.file-status').each image_field_status
	
	$("#location_application_phone").mask("(999) 999-9999");
	
	$('#application-images').on 'fileselect', '.btn-file :file', (event, numFiles, label)->
		$cg = $(this).closest('.control-group')
		$cg.find('.file-status').text(label).removeClass('blank')
	
	$('#application-image-drop').filedrop({
		url: "application"
		allowedfiletypes: ['image/jpeg','image/png','image/gif'],
		allowedfileextensions: ['.jpg','.jpeg','.png','.gif']
		queuefiles: 1
		maxfiles: 10
		maxfilesize: 4
		dragOver: ()->
			$('#application-image-drop').addClass('dragging')
		dragLeave: ()->
			$('#application-image-drop').removeClass('dragging')
		drop: ()->
			$('#application-image-drop').removeClass('dragging')
		data: ()->
			return $("#location_application_form .location-application-image-field :input").serializeArray()
		uploadFinished: (i, file, response, time)->
			$html = $(response).find('#' + $filedropTarget.attr('id'))
			
			image_field_status.apply($html.find('.file-status'))
				
			$filedropTarget.html($html.children())

		beforeSend: (file, i, done)->
			$('#application-image-drop').addClass('loading')
			
			done()
			
		afterAll: ()->
			$('#application-image-drop').removeClass('loading')
		paramname: (filename)->
			
			$emptyInput = $('.location-application-image-field').filter ()->
				empty = true
				$inputs = $(this).find("input")
				for input in $inputs
					if $(input).val() != ""
						return false	
				return true
			.eq(0)
			
			$filedropTarget = $emptyInput
			
			param = $emptyInput.find(":file").attr("name")
			

			return param
			
	})

	

$(document).ready ->
	
	if $('body').hasClass('location_applications')
	
		init_application()
		
		$(document).on 'change', '.btn-file :file', ()->
			$input = $(this)
			numFiles = if $input.get(0).files then $input.get(0).files.length else 1
			label = $input.val().replace(/\\/g, '/').replace(/.*\//, '')
			$input.trigger('fileselect', [numFiles, label])
	
	
		
			
			
		$(document).on 'submit', '#location_application_form', (e)->
			
			$f = $(this)
			
			$f.find("button").button("loading")
			
			
			formURL = $f.attr('action')
			
			if(window.FormData != undefined)
				e.preventDefault()
				formData = new FormData(this)
				
				if formURL.indexOf("application.js") < 0
					formURL = formURL.replace("application", "application.js")
				
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
				return true
	
	
		$(document).on "click", ".scrollbox-nav a", ()->
			$t = $(this)
			direction = if $t.hasClass('up') then 1 else -1
			length = 30
			
			length = length * direction
			$parent = $(this).closest(".scrollbox")
			
			$content = $parent.find(".scrollbox-content")
			topVal = parseInt($content.css("top")) + length
			
			if Math.abs(topVal) > $content.height() - $parent.height()
				topVal = -($content.height() - $parent.height())
				
			if topVal > 0
				topVal = 0
	
			$content.css("top", topVal)