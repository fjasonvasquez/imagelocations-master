!function ($) {

	"use strict";
	
	 function _assetEntityExists($el){
		    var $assetEntityInput = $el.find(":input[name*=id]");
		    if($assetEntityInput.length > 0 && $assetEntityInput.val()){
		    	return parseInt($assetEntityInput.val());
		    }
		    return false;
	    }
	    
    function _assetExists($el){
	    var $assetInput = $el.find(":input[name*=asset_id]");
	    if($assetInput.length > 0 && $assetInput.val()){
	    	return parseInt($assetInput.val());
	    }
	    return false;
    }
	    
	
	function parseTpl(id, tpl){
	    var time = new Date().getTime();
		var regexp = new RegExp(id, "g");
		var $new = $(tpl.replace(regexp, time));
		$new.data('id',time);
		$new.data('base-input-name', $new.data('base-input-name') + "[" + time + "]");
		return $new;
	}
	
	
	
	var sortHelper = function(e, tr){
	    	var $originals = tr.children();
	    	var $helper = tr.clone();
	    	$helper.children().each(function(index){
		    	$(this).width($originals.eq(index).width());
	    	});
	    		
	    	return $helper;
	}
	   
	
	var MultipleAssetUploadField = function(el){
		var $t = $(el)
		,	self = this
		,	assetHeight = $t.data('asset-height')
		,	assetWidth = $t.data('asset-width')
		,	filesWaiting = 0
      	,	$form = $t.closest('form');
      	
      	self.default_photographer_id = false;
      	
      	$t.on("change","select.photographer-select",function(){
	      	
	      	var val = $(this).val();
	      	
	      	if(val == "")
	      		val = false;
	      	
	      	self.default_photographer_id = val;
	      	
      	});
      	
      	var fileUpload = function(){
	      	  return $t.data('blueimp-fileupload') || $t.data('fileupload')
      	}
	    
	    function _calculatePriorities(){
	    	var count = 0;
	    	
	    	var $fields = $t.fileupload('option','filesContainer').children().not('.hide');
	    	
    		$fields.each(function(){
    			var $priorityField = $(this).find(":input[name*=priority]");
    			if($priorityField.length > 0){
	    			$priorityField.val(count);
	    			
	    			var $priorityDisplay = $(this).find('.priority');
	    			if($priorityDisplay.length > 0){
		    			$priorityDisplay.text(count + 1);
	    			}
	    			count++;
    			}
    			
    			
    		});
    	}

	    function _toggleFireActions(){
		      $('.fileupload-buttonbar .cancel, .fileupload-buttonbar .start', $t).toggleClass('hide', filesWaiting < 1);
	    }
	     
	    function _removeAsset($el){
		    //var id = parseInt($el.find(":input[name*=id]").val());
		    var remove = false;
		    
		    
		    if($el.find(":input[name*=id]").val()){
				$el.attr('style','').find(":input[name*=enable]").val("0");
			} else {
				remove = true;
			}
			_calculatePriorities();
			$el.is(":visible");
		    $t.fileupload('option', 'destroy').call($t, null, {
				 context : $el
            }, remove);
	    }
	    
	    function _hasAssetEntity(id){
		    var $existing = $t.fileupload('option','filesContainer').children().find(':input[name*=id][value="'+ id +'"]');
		    if($existing.length > 0){
			    return true;
		    }
		    return false;
		    
	    }
	    
	   
	    
	    function _addFinishedAsset($el){
	    	var uploadFunction = _assetExists($el) ? "done" : "send";
			$el.removeClass('in').is(":visible");
	    	
		    $t.fileupload('option', uploadFunction).call($t, null, {
	    		context: $el,
	    		result: {
		    		files: [$el.data('file')]
	    		}
	    	});
	    }
	    
	    $t.on('click','.watermark',function(e){
		    e.preventDefault();
		    var $btn = $(this);
		    
		    $btn.toggleClass('active');
		    
		    var $input = $(this).closest('li').find(":input[name*=watermark_override]");
			
			if($btn.hasClass('active')) {
				$input.val(1);
			} else {
				$input.val("");
			}

	    });
	    
	     $t.on('click','.watermarkall',function(e){
		    e.preventDefault();
		    
		    $t.fileupload('option','filesContainer').children().each(function(){
			    var $t = $(this);
			    $t.find('.watermark').addClass('active');
			    $t.find(":input[name*=watermark_override]").val(1);
		    });
		   
		    //_removeAsset($el);
		      
	    });
	    
	    $t.on('click','.remove',function(e){
		    e.preventDefault();
		    
		    var $el = $(this).closest('li');
		   
		    _removeAsset($el);
		      
	    });
	    
	   


	    $t.on('click','.removeall',function(e){
		    e.preventDefault();
		    
		    $t.fileupload('option','filesContainer').children().each(function(){
			    
			    _removeAsset($(this));
		    });
		   
		    //_removeAsset($el);
		      
	    });
	    
	    $t.find('.asset-library').on('ajax:before',function(){
	    	var existingIds = [];
	    	$t.fileupload('option','filesContainer').children().not('.hide').each(function(){
	    		var $assetIdField = $(this).find(":input[name*=asset_id]");
	    		if($assetIdField.length > 0 && $assetIdField.val()){
		    		existingIds.push($assetIdField.val());
		    	}
	    	});

	    	$(this).data('params',{existing_ids: existingIds});
	    });
	    
	    $t.find('.asset-library').on('click',function(e){
	    	
		    var $target = $($(this).data('target'));
		    $target.one('shown',function(){
		    	
		    	$target.one('click','img',function(e){
		    		var newAsset = $(this).data('files');
			    	$t.fileupload('option', 'done').call($t, null, {
				    	result: {
				    		files : [newAsset]
				    	}
            		});

		    	});
		    });
		    
	    });
	    
	    $t.on('confirm:complete','.delete',function(e){
	    	e.preventDefault();
	    	var $this = $(this);
	    	            
	    });
	    
	    $(':input[name*=asset_id]').filter(function(){
	    		var val = $(this).val()
	       
            });
	    
	    $t.on('ajax:complete','.delete',function(e){
		    
		    var deleted_id = $(this).closest('li').find(':input[name*=asset_id]').val();
		    
		    var $other_assets = $(':input[name*=asset_id]').filter(function(){
		    	return($(this).val() == deleted_id)
		    })
		    
		    $other_assets.each(function(){
			    $t.fileupload('option', 'destroy').call($t, null, $.extend({
                context: $(this).closest('li')
            }, $(this).closest('li').data()));
			    $(this).closest('li').remove();
		    });
		    
	    });
	    
	    var options = {
	      	  paramName: "asset[source]",
	      	  url: $t.data("url"),
	      	  dropZone: $t,
	      	  pasteZone: null,
	      	  templateId: $t.data("id"),
	      	  prependFiles: false,
	      	  previewAsCanvas: false,
	      	  previewMaxWidth: assetWidth,
	      	  previewMinWidth: assetWidth,
	      	  previewMaxHeight: assetHeight,
	      	  previewMinHeight: assetHeight,
	      	  previewCrop: true,
	      	  uploadTemplateId: null,
	      	  downloadTemplateId: null,
	      	  getFilesFromResponse: function (data) {
                if (data.result && $.isArray(data.result.files)) {
                    return data.result.files;
                }
                return [];
              },
	      	done: function (e, data) {
	      		
                var that = $(this).data('blueimp-fileupload') ||
                        $(this).data('fileupload'),
                    getFilesFromResponse = data.getFilesFromResponse ||
                        that.options.getFilesFromResponse,
                    files = getFilesFromResponse(data),
                    template,
                    deferred;
                    
                    
                if (data.context) {
                    data.context.each(function (index) {
                        var file = files[index] || {error: 'Empty file upload result'},
                            deferred = that._addFinishedDeferreds();
                        
                        
                        if(typeof files[index] != "undefined"){
	                        files.splice(index, 1);
                        }
                           
                        that._transition($(this)).done(
                            function () {
                                var node = $(this);
                                template = that._renderDownload([file])
                                    .replaceAll(node);
                                that._forceReflow(template);
                                that._transition(template).done(
                                    function () {
                                        data.context = $(this);
                                        that._trigger('completed', e, data);
                                        that._trigger('finished', e, data);
                                        deferred.resolve();
                                    }
                                );
                            }
                        );
                    });
                }
                if(files.length > 0){
                    template = that._renderDownload(files)
                        .appendTo(that.options.filesContainer);
                    that._forceReflow(template);
                    deferred = that._addFinishedDeferreds();
                    that._transition(template).done(
                        function () {
                            data.context = $(this);
                            that._trigger('completed', e, data);
                            that._trigger('finished', e, data);
                            deferred.resolve();
                        }
                    );
                }
               
            },
	      	  destroy: function (e, data, remove) {
	      	  	remove = typeof remove != "undefined" ? remove : false;
	      	  	
                var that = $(this).data('blueimp-fileupload') || $(this).data('fileupload');
                if (data.url) {
                    that._adjustMaxNumberOfFiles(1);
                }
                that._transition(data.context).done(
                    function () {
                    	if(remove){
                    		//console.log('removing');
	                    	$(this).remove();
                    	} else {
	                    	$(this).addClass('hide');
                    	}
                        
                        that._trigger('destroyed', e, data);
                    }
                );
            },
            uploadTemplate: function (o) {
	      	  	var rows = $();
	      	  	
		        $.each(o.files, function (index, file) {
		        	
		        	var $tpl = parseTpl(o.options.templateId,o.options.uploadTpl).data('file',file);
		        	//$tpl.data('files',files);
		        	
		        	$tpl.find(":input[name*=type]").val("Image");
		        	$tpl.find('.preview').width(assetWidth).height(assetWidth);
		        	
		        	//$tpl.find('.name').text(file.name);
		            //$tpl.find('.size').text(o.formatFileSize(file.size));
		            if (file.error) {
		                $tpl.find('.error').text(
		                    locale.fileupload.errors[file.error] || file.error
		                );
		            }
		            
		            
		            rows = rows.add($tpl);
		        });
		        return rows;
	      	  },
	      	  downloadTemplate: function (o) {
			        var rows = $();
					
			        $.each(o.files, function (index, file) {
			        	//console.log('downlaod-template');
			        	//console.log(o.files.length);
			        	var $tpl = parseTpl(o.options.templateId,o.options.downloadTpl).data('file',file);
			        	
			        	
			        	if(file.error){
				        	var error = ' <td class="error" colspan="2"><span class="label label-important"></span></td>';
			        	}
			        	
			            //$tpl.find('.size').text(o.formatFileSize(file.size));
			            if (file.error) {
			                $tpl.find('.name').text(file.name);
			                $tpl.find('.error').text(
			                    locale.fileupload.errors[file.error] || file.error
			                );
			            } else {
			                $tpl.find('.name a').text(file.name);
			                
			                
			                if (file.thumbnail_url) {
			                    $tpl.find('.preview').append('<a><img></a>')
			                        .find('img').prop('src', file.thumbnail_url);
			                    $tpl.find('a').prop('rel', 'gallery');
			                }
			                
			                if(file.asset_entity_id){
				                $tpl.find(":input[name*=id]").first().val(file.asset_entity_id);
				                
			                }
			                //Add asset ID
			               // console.log($tpl.find(":input[name*=\\[asset_attributes\\]\\[id\\]]"));
			                //$tpl.find(":input[name*=\\[asset_attributes\\]\\[id\\]]").val(file.id);
			                $tpl.find(":input[name*=asset_id]").val(file.id);
			                //$tpl.find('a').prop('href', file.url);
			                $tpl.find('.edit')
			                	.attr('href', file.edit_url);
			                $tpl.find('.delete')
			                    .attr('href', file.delete_url);
			            }
			            rows = rows.add($tpl);
			        });
			        return rows;
			    }
	      }	    


	      $t.fileupload(options);
	      
	      var fileup = $t.data('blueimp-fileupload');
	      	    
	      $t.fileupload('option','filesContainer').sortable({
			//connectWith: '[data-multiple-upload!=""]',
			handle: ".preview",
			delay: 50,
			items: "> li",
			tolerance: "pointer",
			forceHelperSize: true,
			forcePlaceholderSize: true,
			
			update: function(event, ui){
				if(ui.item.data('unprocessed')){
					var file = ui.item.data('file');
					
					file.asset_entity_id = false;
					 ui.item.data('file', file);
					 
					 
					_addFinishedAsset(ui.item);
					//console.log(ui.item.is(':visible'));
					ui.item.data('unprocessed',false);
				}
			},
			start: function(event, ui){
				
				ui.placeholder.height(Math.floor(ui.item.height() - 4));
				ui.placeholder.width(Math.floor(ui.item.width() - 4));			
			},
			stop: function(event, ui){
				_calculatePriorities();
			}
		});
		
				
		$t.fileupload('option','filesContainer').on( "sortreceive", function( event, ui ) {

			
			ui.item.data('unprocessed', true);
			
		} );
	      
	    $t.fileupload('option','filesContainer').on( "sortremove", function( event, ui ) {
			
			ui.item.unbind($.support.transition.end);
			
			var exists = _assetEntityExists(ui.item);
			if(exists){
				var $clone = $("<div class='hide'/>").html(ui.item.find(":input").clone());
				
				$(this).after($clone);
				
			}
			
		} );
	      
	      $t.on('fileuploadcompleted', function(e, data){
		  	//console.log(data.context);
		  	_calculatePriorities();
		  	//console.log(data);    
		    
	      });
	      
	      $t.bind('fileuploaddone fileuploadfail', function(e, data){
		     filesWaiting--;
		     _toggleFireActions();
		     _calculatePriorities();
		     
		   
	      });
	      
	      $t.bind('processdone', function (e, data) {
		      
		      
		     
		      
	      });
	      
	      $t.fileupload('option','filesContainer').on('fileuploadadded fileuploaddestroyed', function (e, data) {
	      	//console.log('added destroyed');
	      });
	      
	      $t.bind('fileuploadadded', function (e, data) {
	      	
	      	filesWaiting++;
	      	
	      	if(typeof data.fileInput == "undefined"){
		      	data.submit();
	      	} else {
		      	
	      		data.context.find(":input[name*=type]").val("Image");
		      	data.fileInput.attr("name",data.context.data('base-input-name') + "[asset_attributes][source]").hide();
		      	data.context.append(data.fileInput);
	      	}
	      	
	      	_calculatePriorities();
	      	_toggleFireActions();
	      	$(document).trigger('init-admin-plugins');
	      }); 
	      $t.bind('fileuploadsubmit', function (e, data) {

			  	var templateRowId = data.context.data('id')
			  		, assetBase = data.context.data('base-input-name') + "[asset_attributes]"
			  		, assetData = data.context.find(':input').serializeArray();
			  	
			  	for(var i=0;i<assetData.length;i++){
			      	var name = assetData[i]['name'];
			      	assetData[i]['name'] = name.replace(assetBase,"asset");
			  	}
			  	//console.log(assetData);
			  	
			  	if(self.default_photographer_id)
			  		assetData.push({ name: "asset[photographer_id]", value: self.default_photographer_id})
			  	
			  	data.formData = assetData;
		});
		
		$t.fileupload('option','filesContainer').children().each(function(){
			
			_addFinishedAsset($(this));			
					
		});
		
		_calculatePriorities();
		//console.log('what');
	};
      
     $.fn.multipleAssetUploadField = function () {
		return this.each(function () {
			var $this = $(this),
				data = $this.data('multiple-upload');

			if (!data) $this.data('multiple-upload', (data = new MultipleAssetUploadField(this)));
		})
	};
}(window.jQuery);