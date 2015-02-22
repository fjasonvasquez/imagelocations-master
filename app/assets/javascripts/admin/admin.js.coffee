//= require jquery.ui.all
//= require jquery.deserialize
//= require bootstrap
//= require bootstrap/confirm
//= require bootstrap/fileupload
//= require bootstrap/bootstrap-select
//= require bootstrap-modal
//= require bootstrap-modalmanager
//= require bootstrap-wysihtml5
//= require rails.validations
//= require rails.validations.simple_form
//= require select2
//= require jquery-fileupload
//= require file_uploader
#//= require site_content_form
//= require rails-timeago
#//= require keyword_field
//= require holder
//= require asset_uploader
//= require admin_modal
//= require d3
//= require xcharts
//= require iscroll-lite
//= require left-panel
//= require tag_select_2
//= require keyword_select_2
//= require related_entities
//= require slug_field
//= require flash_messages

initAdmiPlugins = (e)->
	#$('.keyword-taxonomy-field').keywordField ->
	$('.selectpicker').selectpicker ->
	
	$('select.select2').select2
		width: "resolve"
	
	$('select.photographer-select').select2
		width: "resolve",
		allowClear: true
	
	$('select.publication-category-select').select2
		width: "resolve",
		allowClear: true
	
	$('select.tag-select2').tagSelect2 ->
	
	$('input.keyword-select2').keywordSelect2 ->
	
	$('.related-entities').relatedEntities ->
	
	$('.slug-field').slugField ->
	
	#$('.site_content_form').siteContentForm ->
	$('.multi-asset-upload-field').multipleAssetUploadField ->
	if(e.type == "init-admin-plugins")
		e.stopPropagation()
		return false
	
	

$(document).on 'init-admin-plugins ajax:complete', initAdmiPlugins
	
$(document).ready ->
	$('body').tooltip
		selector: '.btn-tooltip'
	
	$('input[type=checkbox].check-all').on "change", (e)->
		$t = $(this)
		isChecked = $t.is(":checked")
		$t.closest('form').find("input[type=checkbox]").each ()->
			$check = $(this)
			$check.prop("checked",isChecked)
	
	$.adminModal ->
	#$('textarea.wysiwyg').each (i, elem)->
	#	$(elem).wysiwyg();
	#$('.file-uploader-field').fileUploadField()
	$(document).trigger('init-admin-plugins')
	
	$(document).on 'change', 'select.per-page',(e)->
		$(this).closest('form').submit()
	