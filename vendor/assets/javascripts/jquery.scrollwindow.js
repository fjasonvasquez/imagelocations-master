(function($){
	var $bg;
	
	$.scrollWindow = function(options){
		if(!$('body').hasClass('scroll-closed')){
			return;
		}
		
		$bg = $('#bg-slides');
		
		$('.scroll-container').each(function(){
			
			if(typeof $(this).data('scroller') == "undefined"){
				
				var scroller = new Scroller($(this));
				$(this).data('scroller', scroller);
			}
			
			return $(this);
			
		});
		
	};
	
	var Scroller = function($el){
		var t = this,
			wScrollTop = 0,
			fOpacity = .4,
			wHeight = $(window).height(),
			thresh = 5,
			$scrollEl = $el.find('.scroll-element'),
			$bB = $('.scroll-down-button'),
			bBHeight = $bB.height();
			
			
			if($bB.length < 1){
				$bB = $('<div class="scroll-button scroll-down-button"><div class="scroll-button-wrap"/></div>');
			
				$bB.appendTo('#wrapper');
			}
			
			var $b = $('.scroll-button');
			
			var $db = $('.scroll-top');
			
			$(document).on("click", ".scroll-top",function(e){
				e.preventDefault();
				t.scrollDown();
				
			});
			
			
			$b.on('click',function(e){
				e.preventDefault();
				t.scrollUp();
			});
			
			$(window).on('scroll',function(){
				wScrollTop =  $(window).scrollTop();
				wHeight = $(window).height();
				var r = wScrollTop / wHeight;
				
				if(r <= 1){

					$bB.css('bottom', -(Math.ceil(r*bBHeight)));
					
					var f = 1 - ((1-fOpacity) * r);
					$bg.css({
						opacity : f
						
					});
				}
				
				//console.log(wScrollTop / wHeight);
				$('body').toggleClass('scroll-closed', wScrollTop <= wHeight)
			});
			
			
			$bB.on('mouseenter',function(){
				bounce($bB);
			});
			
			$('body').on('mousewheel', function(event, delta) {
				
				if(delta < -thresh){
					//t.scrollUp();
				} else if($(window).scrollTop() <= 0 && delta > thresh*4){
					//t.scrollDown();
				}
    		});
		
		t.scrollUp = function(){
			var h = $(window).height();
			
	
			$("html, body").stop(false, true).animate({
				scrollTop: h - 120
			},{
				
				complete: function(){
					//$('body').removeClass('scroll-animating');
				}
			});			
		}
		
		t.scrollDown = function(){
			$("html, body").stop(false, true).animate({
				scrollTop: 0
			},{
				
				complete: function(){
					//$('body').removeClass('scroll-animating');
				}
			});			
		}
		
		if(window.location.hash == "#scrolldown"){
				t.scrollUp();
		} else {
			bounce($b);
		}
	}
	
	function bounce($el){
		$el.find('.scroll-button-wrap').stop().animate({
					'bottom' : '-=7px'
				},{
					easing: 'easeOutBounce',
					duration: 100,
					complete: function(){
							
						$(this).animate({
							'bottom' : 0
						},{
							duration: 100
						});
					}
				});
	}


})(jQuery);
