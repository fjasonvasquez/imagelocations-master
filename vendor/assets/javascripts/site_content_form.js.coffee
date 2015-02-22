$ = jQuery

$.fn.siteContentForm = () ->
  @each ->
  	$form = $(this)
  	if typeof $form.data('SiteContentForm') == "undefined"
  		plugin = new SiteContentForm($form)
  		$form.data('SiteContentForm', plugin)
  	else
  		plugin = $form.data('SiteContentForm')
  	
  	return plugin


SiteContentForm = ($form) ->
	t = this
	activeSite = $form.data('site')
	element_prefix = $form.data('element-prefix')
	
	$actionBar = $form.find('.nav-entity-actions')
	
	$actionBtns = $form.find('.nav-entity-actions button')
	$siteDropDown = $form.find('.site-dropdown-tab')
	$siteTabs = $form.find('.site-tab')
	$siteChecks = $form.find('.site-enable');
	
	#Btn actions
	#Btn remove
	$actionBtns.filter('.site-remove').click (e) ->
		e.preventDefault()
		t.removeSite(activeSite)
	
	#Add Bootstrap Dropdown
	$siteDropDown.find('.dropdown-toggle').dropdown()
	
	$siteDropDown.find('.dropdown-menu a').click (e) ->
		e.preventDefault()
		t.addSite($(this).data('site'))
	
	#Add Bootstrap tab function
	$siteTabs.children('a').click (e) ->
  		e.preventDefault()
  		$(this).tab('show');
  		#$(href).show()
  	
  	#Callback on show
  	$siteTabs.children('a').on 'show',(e)->
  		$target = $(e.target);
  		$previous = $(e.relatedTarget);
  		console.log e
  		activeSite = $target.data('site')
  		$prevActionTab = $($previous.attr('href') + "-actions")
  		$prevActionTab.removeClass('active')
  		$nextActionTab = $($target.attr('href') + "-actions")
  		$nextActionTab.addClass('active')
  		toggleActionBtns()
  	
  	
  	t.removeSite = (id) ->
  		deactivateTab(id)
  		$siteDropDown.find('.site-' + id).removeClass('hide')
  		toggleSite(id,false)
  		toggleDrop()
  	
  	t.addSite = (id) ->
  		$siteDropDown.find('.site-' + id).addClass('hide')
  		
  		toggleDrop()
  		activateTab(id)
  		#Activate checkbox
  		toggleSite(id, true)
  		
  	activateTab = (id) ->
  		$tab = $siteTabs.filter('.site-' + id)
  		$siteDropDown.before $tab
  		$tab.removeClass('hide').children('a').tab('show')
  	
  	deactivateTab = (id) ->
  		$tab = $siteTabs.filter('.site-' + id)
  		$tab.addClass('hide')
  		next_active_id = $siteTabs.filter(':not(.hide)').last().children('a').data('site') || 0
  		activateTab(next_active_id)
  	
  	toggleDrop = ->
  		$siteDropDown.toggleClass('hide', $siteDropDown.find('.dropdown-menu li:not(.hide)').length <= 0 )
  	
  	toggleSite = (id,checked) ->
  		$("#" + element_prefix + "-site-" + id + " .site-enable").prop('checked', checked)
  	
  	toggleActionBtns = ->
  		$actionBar.toggleClass('hide', activeSite <= 0)