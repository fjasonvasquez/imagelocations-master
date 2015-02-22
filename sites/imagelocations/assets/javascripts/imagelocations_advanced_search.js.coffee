$(document).ready ->
	$('#advanced-search').each ()->
		$t = $(this)
		
		
		setMaxHeight = ()->
			$t.children().css({
				maxHeight: $(window).height() - ($t.innerHeight() - $t.height() - $t.offset().top)
			})
		
		drillDown = (el)->
			$el = $(el)
			$t.find('.back').removeClass('hide')
			$el.addClass('in').parent().closest('ul').animate({
					left: "-100%"
				}
			)
			
			$t.find('.search-options').animate({
				height: $el.height()
			})
			
			
			
		drillUp = (el)->
			$el = $(el)
			$t.find('.back').addClass('hide')
			$el.parent().closest('ul').animate({
					left: "0"
				},{
					complete: ()->
						$el.removeClass('in')
				}
			)
			
			$t.find('.search-options').animate({
				height: $el.parent().closest('ul').height()
			})

		formatSelectionLabel = ($i)->
			$p = $i.closest('ul')
			$span = $p.parent().find('a.option span')
			labels = []
			$p.find(':checked').each ()->
				labels.push($(this).next('label').text())
			
			if(labels.length < 1)
				$span.text($span.data('placeholder'))
			else
				$span.text(labels.join())
			
			if $p.children('li').length < 2
				drillUp($p)
			
			
		
		$(document).on 'click','#advanced-search ul li a',()->
			drillDown($(this).next('ul'))
		
		$(document).on 'click','#advanced-search .back',()->
			drillUp($t.find('ul li ul.in'))
	
				
		$(document).on 'click','#advanced-search ul li label',(e)->
			e.preventDefault()
			$p = $(this).parent()
			$i = $p.find('input')
			
			$p.toggleClass('on', !$i.prop("checked"))
			$i.prop("checked", !$i.prop("checked"))
			formatSelectionLabel($i)
			
			
		
		$(document).on 'click','#advanced-search .close', (e)->
			$t.slideUp(300)
			
		$(document).on 'click', '[target=#advanced-search]', (e)->
			e.preventDefault()
			$t.slideDown(300)
			
		$(window).on 'resize',setMaxHeight
		
		setMaxHeight()