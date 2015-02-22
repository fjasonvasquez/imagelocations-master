$(document).ready(function(){
	  		var flash = JSON.parse($.cookie("flash"));
	  		
	  		if(flash){
	  			$.each(flash,function(i,val){
		  			var $msg = $(val)
		  			$("#flash-messages").append($msg);
		  			
	  			});
		  		$.removeCookie('flash', { path: '/' });	
	  		}
	  	});