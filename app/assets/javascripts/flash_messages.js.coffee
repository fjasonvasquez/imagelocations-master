//= require jquery.cookie

$(document).ready ->
	flash = JSON.parse($.cookie("flash"))
	if(flash)
		$.each flash,(i,val)->
			$("#flash-messages").append(val)
		
		$.removeCookie('flash', { path: '/' })