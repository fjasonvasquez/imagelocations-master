$ = jQuery

AdminModal = (options)->
	t = this		
	return this.init(options)



AdminModal.prototype =
	constructor: AdminModal,
	modalEl:()->
		return this.$el
	removeLoading: ()->
		this.$el.modal('removeLoading')
	setTitle: (title)->
		this.$el.find('.modal-title').text(title)
	setBody: (html)->
		$body = this.$el.find('.modal-body')
		$body.html(html)
	setFooter: (html)->
		this.$el.find('.modal-footer').html(html)
	setModalClass: (c)->
		t.$el.addClass(c)
	show: (e)->
		this.isShown = true
		this.$el.modal('show')
	hide: ()->
		this.$el.modal('hide')
		this.isShown = false
	init: (options)->
		t = this
		#this.options = options;
		t.options = options
		t.isShown = false
		t.selector = '[data-target=' + t.options.elementId + ']'
		t.$el = $(t.options.elementId)
		t.defaultClasses = t.$el[0].className
		t.defaultFooter = t.$el.find('.modal-footer').html()
		#t.$el.on 'show', ->
		#	this.isShown = true
		#console.log t.defaultClasses
		t.$el.modal
			backdrop: true
			show: false
			
				
		#t.$el.on 'hide', ->
			#t.$el.one "hidden", ->
				#t.$el.attr('class', t.defaultClasses)
				#t.setTitle("")
				#t.setBody("")
				#t.setFooter(t.defaultFooter)
		#	t.hide();
			#$($ttitle,$tbody,$tfooter).empty()
					
		
		
		#$(document).on 'ajax:success', t.selector, (e, data)->
			#$bodyContent = $('#ajax-modal-body-content')
			#$bodyContent.on 'ajax:complete', (e, data)->
			#	console.log('complete')
			#	$('#ajax-modal').modal('hide')
			
			#t.$el.find('[type=submit]').addClass('ajax-added').on "click", (e)->
			#	t.$el.find('form').submit()
			#.appendTo($('#ajax-modal .modal-footer'))
		
		$(document).on 'click', t.selector, (e)->
			e.preventDefault()
			e.stopPropagation()
			$this = $(this)
			remote = typeof $this.data('remote') != "undefined"
			
			if remote
				t.setTitle $this.data('title')
				$('body').modalmanager 'loading'
				$this.one 'ajax:complete', (e, data)->
					t.show();
			
		$(document).on 'ajax:complete', '[data-remote=true]',(e)->
			#console.log this
		
		t.$el.on 'click', t.selector,(e)->
			t.$el.modal('loading')
			t.$el.one 'ajax:complete', (e, data)->
				console.log this
		#$(document).on 'click', t.selector, (e) ->
		#	e.stopPropagation();
			
		#t.backdrop();
		
		return this

$.adminModal = (option, args) ->
	$this = $('body')
	data = $this.data('admin-modal')
	options = $.extend({}, $.adminModal.defaults, typeof option == 'object' && option)
	
	if (!data)
		$this.data('admin-modal', (data = new AdminModal(options)))
	if typeof option == 'string'
		data[option].apply(data, [].concat(args))
  	
$.adminModal.defaults =
		elementId: '#ajax-modal'

$.adminModal.Constructor = AdminModal