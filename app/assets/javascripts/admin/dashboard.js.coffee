# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
	if $('body').hasClass('dashboard')
		
		
		
		tt = document.createElement("div")
		tt.className = "ex-tooltip"
		document.body.appendChild tt
		
		visitsChart = (data)->
			vizdata =
				xScale: "ordinal"
				yMin: 0.1
				yScale: "linear"
				main: [
					className: ".pizza"
					data: data
				]
		
			opts =
				dataFormatX: (x) ->
					d3.time.format("%Y-%m-%d").parse x
				
				tickFormatX: (x) ->
					d3.time.format("%A") x
				
				paddingLeft: 30
				
				mouseover: (d, i) ->
					pos = $(this).offset()
					$(tt).text(d3.time.format("%A")(d.x) + ": " + d.y).css(
						top: pos.top - 28
						left: pos.left + 5
					).show()
				mouseout: (x) ->
					$(tt).hide()
			
			myChart = new xChart("line-dotted", vizdata, "#visitsChart", opts)
		
		topLocationsWidget = (data)->		
			$el = $("#top-chart-wrap")
			
			getw = $el.width() - 24
			
			maxviews = d3.max(data, (d) ->
			 d.views
			)
			
			interval = Math.round(getw / maxviews)
			
			topchart = d3.select("#top-chart-wrap").append("div").attr("class", "bchart")
			
			topchart.selectAll("div").data(data).enter().append("a").style("width", (d) ->
			 d.views * interval + "px"
			).attr("href", (d) ->
			 d.path
			).html (d) ->
			 d.location + "<span class='right'>" + d.views + "</span>"
		
		$.ajax({
				url : "/admin/dashboard.json"
				dataType: "json"
				success: (data)->
					$('.icon-spinner').addClass('hide')
					if(data['top_locations'])
						topLocationsWidget(data['top_locations'])
					
					if(data['visits'])
						visitsChart(data['visits'])
						
						
					if(data['visits_this_week'])
						$('#visits-count').text(data['visits_this_week'])
		})
			 



