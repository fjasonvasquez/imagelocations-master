$ = jQuery



MoodBoard = (el,options)->
	t = this
	$el = $(el)
	options = $.extend({
		itemWrap: "div",
		deleteHtml: "<a class='btn btn-primary btn-mini moodboard-delete' href='#'><i class='icon-remove'></></a>"
	},$el.data())
	
	$emailModal = $('#pdf-email-modal')
	$emailForm = $('#new_pdf_email')
	
	
	$pdfModal = $('#pdf-modal')
	$pdfForm = $pdfModal.find('form')
	
	ids_param = $pdfForm.find(':input[name*=asset_entity_ids]').attr('name')
	
	
	getData = ()->
		data = $.cookie('moodboard')
		if !data
			data = []
		else
			data = JSON.parse(data)
		return data
		
		
	setData = ()->
		data = []
		$content.find('[data-asset-entity]').each ()->
			data.push {
				asset_entity_id: $(this).data('asset-entity')
				src: $(this).attr('src')
			}
		$.cookie('moodboard',JSON.stringify(data),{ expires: 7, path: '/' })
	
	cloneImg = ($img)->
		return elWrap().append($img.clone().attr('class','')).append(options.deleteHtml)
	
	elWrap = ()->
		return $(document.createElement(options.itemWrap))
		
	$container = $el.find('.moodboard-inner')
	$content = $el.find('.moodboard-content')
	
	for d in getData()
		img = new Image()
		img.src = d.src
		elWrap().append($(img).attr('data-asset-entity',d.asset_entity_id)).append(options.deleteHtml).appendTo($content)
		
	
	closeTriggered = false
	
	
	$el.on 'click', '.close',(e)->
		e.preventDefault()
		t.close()
	
	$el.on 'click', '.open',(e)->
		e.preventDefault()
		if(t.visible())
			t.close()
		else
			t.open()
	
	$el.on 'click', '.email-pdf',(e)->
		e.preventDefault()
		emailPdf()
		
	$el.on 'click', '.generate-pdf',(e)->
		e.preventDefault()
		generatePdf()
	


		
	$container.droppable({
		hoverClass: "hovering"
		activeClass: "dragging"
		greedy: true
		accept: (item)->
			$content.has(item).length < 1 && parseInt(item.data('asset-entity')) > 0
		drop: ( event, ui )->
			t.addTo(ui.draggable)
			closeTriggered = false
	})
	
	$content.sortable({
		#connectWith: '[data-asset-entity]'
		#helper: 'clone'
		#appendTo: document.body
		dropOnEmpty: false
		items: '> li'
		over: (e, ui)->
			ui.item.removeClass('remove')
			true
		out: (e, ui)->
			ui.item.addClass('remove')
			true
		beforeStop: (e, ui)->
			if ui.item.hasClass('remove')
				t.removeFrom(ui.item.find('[data-asset-entity]'))
				ui.item.remove()
		stop: (e,ui)->
			ui.item.attr('class','')
			setData()

			
	}).disableSelection()
	
	
	
	
	t.disableDrag = ()->
		$('[data-asset-entity]:not(.moodboard [data-asset-entity])').draggable( 'disable' )
		
	t.enableDrag = ()->
		$('[data-asset-entity]:not(.moodboard [data-asset-entity])').draggable( 'enable' )
	
	t.visible = ()->
		$el.find('.moodboard-menu').is(':visible')
	
	t.open = (cb)->
		$.cookie('moodboard_window',1)
		
		
		$el.find('.moodboard-menu').addClass('sliding').slideDown(
			150,
			()->
				$(this).removeClass('sliding')
				$el.addClass('moodboard-open')
				t.enableDrag()
				if cb
					cb()
		)
	
	t.close = (cb)->
		$.cookie('moodboard_window',0)
		$el.find('.moodboard-menu').addClass('sliding').slideUp(
			150,
			()->
				$(this).removeClass('sliding')
				$el.removeClass('moodboard-open')
				t.disableDrag()
				if cb
					cb()
		)	
	
	t.addTo = ($img)->
		cloneImg($img).appendTo($content)
		setData()
		
	t.removeFrom = ($img)->
		$img.remove()
		setData()
	
	setDraggable = ()->
		$('[data-asset-entity]:not(.moodboard [data-asset-entity])').draggable({
			appendTo: "body"
			#containment: "body"
			helper: 'clone'
			#drop: (e,ui)->
			#	console.log(ui)
			disabled: true
			cursorAt:
				left: 100
				top: 60
			stop: (e, ui)->
				clearTimeout(closeTriggered)
				if(closeTriggered)
					t.close()
				true
			start: (e, ui)->
				
				ui.helper.css({
					width: 200
					height: "auto"
            	})
				#if !t.visible()
				#	closeTriggered = setTimeout(
				#						()->
				#							t.open()
				#						400)
		})

	setDraggable()
	
	$(document).on "ajax:complete", "[data-remote=true]", ()->
		setDraggable()
	
	emailPdf = ()->
		ids = getIds()
		if !ids.length
			return;
		
		$emailModal.modal('show')
		
	generatePdf = ()->
		ids = getIds()
		if !ids.length
			return;
		$pdfModal.modal('show')
	
	getIds = ()->
		ids = []
		for d in getData()
			ids.push d.asset_entity_id		
		return ids
	
	
	$pdfModal.find('button[type=submit]').on 'click',(e)->
		e.preventDefault()
		
		title = $pdfModal.find(':input[name*=title]').val()
		$pdfForm.trigger('submit')
		
		
	
	$pdfForm.on 'submit', (e,d)->
		$t = $(this)
		$t.attr('target','_blank');
		$t.find(':input[name*=asset_entity_ids]').remove()
			
		($t.append($('<input name="' + ids_param + '"/>').attr('type','hidden').val(id)) for id in getIds())
		$pdfModal.modal('hide');
		
		
		true
	
	if parseInt($.cookie('moodboard_window'))
		$el.addClass('moodboard-open')
		t.enableDrag()
	
	$emailModal.find('button[type=submit]').on 'click',(e)->
		e.preventDefault()
		$emailForm.trigger('submit.rails')	
	
	
	$emailForm.on 'ajax:before',()->
		$btn = $emailModal.find('button[type=submit]')
		$btn.button('loading')
		$emailForm.find(':input[name*=asset_entity_ids]').remove()
		($emailForm.append($('<input name="' + ids_param + '"/>').attr('type','hidden').val(id)) for id in getIds())
		
		$(this).one 'ajax:complete',()->
			$btn.button('reset')
	
	$emailForm.on 'ajax:bseforeSend',(e, xhr,s)->
		data = ({name: ids_param, value: id} for id in getIds())		
		s.data = $.param($.extend($(this).serializeArray(),data))

	$emailForm.on 'element:validate:fail.ClientSideValidations',(e)->
		$emailModal.find('button[type=submit]').button('reset')
	
	
	$(document).on "click", ".moodboard-delete", (e)->
		e.preventDefault();
		t.removeFrom($(this).parent());
	
	return this
	
	
$.fn.moodBoard = (options) ->	
	@each ->
		$this = $(this)
		data = $this.data('MoodBoard')
		if (!data) 
			$this.data('MoodBoard', (data = new MoodBoard(this,options)))


$(document).ready ->
	$('.moodboard').moodBoard();