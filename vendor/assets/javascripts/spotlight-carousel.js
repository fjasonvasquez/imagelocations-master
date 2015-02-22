(function(){
 
  /* ==========================================================
   * bootstrap-Spotlight.js v2.3.1
   * http://twitter.github.com/bootstrap/javascript.html#Spotlight
   * ==========================================================
   * Copyright 2012 Twitter, Inc.
   *
   * Licensed under the Apache License, Version 2.0 (the "License");
   * you may not use this file except in compliance with the License.
   * You may obtain a copy of the License at
   *
   * http://www.apache.org/licenses/LICENSE-2.0
   *
   * Unless required by applicable law or agreed to in writing, software
   * distributed under the License is distributed on an "AS IS" BASIS,
   * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   * See the License for the specific language governing permissions and
   * limitations under the License.
   * ========================================================== */
  
  
  !function ($) {
  
    "use strict"; // jshint ;_;
  
  
   /* Spotlight CLASS DEFINITION
    * ========================= */
  
    var Spotlight = function (element, options) {
      this.$element = $(element)
      this.$clone = this.$element.find('.spotlight-clone')
      this.$indicators = this.$element.find('.spotlight-indicators')
      this.options = options
      this.options.pause == 'hover' && this.$element
        .on('mouseenter', $.proxy(this.pause, this))
        .on('mouseleave', $.proxy(this.cycle, this))
    }
  
    Spotlight.prototype = {
  
      cycle: function (e) {
        if (!e) this.paused = false
        if (this.interval) clearInterval(this.interval);
        this.options.interval
          && !this.paused
          && (this.interval = setInterval($.proxy(this.next, this), this.options.interval))
        return this
      }
  
    , getActiveIndex: function () {
        this.$active = this.$element.find('.spotlight-inner .item.active')
        this.$items = this.$active.parent().children()
        return this.$items.index(this.$active)
      }
  
    , to: function (pos) {
        var activeIndex = this.getActiveIndex()
          , that = this
		
        if (pos > (this.$items.length - 1) || pos < 0) return
  
        if (this.sliding) {
          return this.$element.one('slid', function () {
            that.to(pos)
          })
        }
  
        if (activeIndex == pos) {
          return this.pause().cycle()
        }
		
		
		
        return this.slide(pos > activeIndex ? 'next' : 'prev', $(this.$items[pos]))
      }
  
    , pause: function (e) {
        if (!e) this.paused = true
        if (this.$element.find('.next, .prev').length && $.support.transition.end) {
          this.$element.trigger($.support.transition.end)
          this.cycle(true)
        }
        clearInterval(this.interval)
        this.interval = null
        return this
      }
  
    , next: function () {
        if (this.sliding) return
        return this.slide('next')
      }
  
    , prev: function () {
        if (this.sliding) return
        return this.slide('prev')
      }
  
    , slide: function (type, next) {
        var $active = this.$element.find('.spotlight-inner .item.active')
          , $clone = this.$clone.find('.item.active')
          , $next = next || $active[type]()
          , isCycling = this.interval
          , direction = type == 'next' ? 'left' : 'right'
          , fallback  = type == 'next' ? 'first' : 'last'
          , that = this
          , e
          , eClone
          , $beforeClone
		
        this.sliding = true
  
        isCycling && this.pause()
		
		
	
        $next = $next.length ? $next : this.$element.find('.spotlight-inner .item')[fallback]()
       
        
        var $before = $next.prev().length ? $next.prev() : this.$element.find('.spotlight-inner .item').not('.active').last();
        
        $beforeClone = $before.clone();
        $beforeClone.attr('class','').appendTo(this.$clone);
        //$before.addClass('clone').removeClass('active');
		
		
		console.log($before);
		
        e = $.Event('slide', {
          relatedTarget: $next[0]
        , direction: direction
        })
        
          
        if ($next.hasClass('active')) return
  
        if (this.$indicators.length) {
          this.$indicators.find('.active').removeClass('active')
          this.$element.one('slid', function () {
            var $nextIndicator = $(that.$indicators.children()[that.getActiveIndex()])
            $nextIndicator && $nextIndicator.addClass('active')
          })
        }
		
        if ($.support.transition && this.$element.hasClass('slide')) {
          
          this.$element.trigger(e)
          //this.$element.trigger(eClone)
          
          if (e.isDefaultPrevented()) return
          $next.addClass(type)
          $beforeClone.addClass(type).addClass('item')
          
          $next[0].offsetWidth // force reflow
          $beforeClone[0].offsetWidth
          
          $clone.addClass(direction)
          $active.addClass(direction)
          $next.addClass(direction)
          
          this.$element.one($.support.transition.end, function () {
            $next.removeClass([type, direction].join(' ')).addClass('active')
            $beforeClone.removeClass([type, direction].join(' ')).addClass('active')
            
            $active.removeClass(['active', direction].join(' '))
            $clone.removeClass(['active', direction].join(' '))
            
            that.sliding = false
            setTimeout(function () { 
            	that.$element.trigger('slid');
	            $clone.remove();
	            //console.log(that);
            }, 0)
          })
        } else {
          this.$element.trigger(e)
          if (e.isDefaultPrevented()) return
          $active.removeClass('active')
          $next.addClass('active')
          this.sliding = false
          this.$element.trigger('slid')
        }
  
        isCycling && this.cycle()
  
        return this
      }
  
    }
  
  
   /* Spotlight PLUGIN DEFINITION
    * ========================== */
  
    var old = $.fn.Spotlight
  
    $.fn.Spotlight = function (option) {
      return this.each(function () {
      	
        var $this = $(this)
          , data = $this.data('Spotlight')
          , options = $.extend({}, $.fn.Spotlight.defaults, typeof option == 'object' && option)
          , action = typeof option == 'string' ? option : options.spotlightSlide
        if (!data) $this.data('Spotlight', (data = new Spotlight(this, options)))
        if (typeof option == 'number') data.to(option)
        else if (action) data[action]()
        else if (options.interval) data.pause().cycle()
      })
    }
  
    $.fn.Spotlight.defaults = {
      interval: 5000
    , pause: 'hover'
    }
  
    $.fn.Spotlight.Constructor = Spotlight
  
  
   /* Spotlight NO CONFLICT
    * ==================== */
  
    $.fn.Spotlight.noConflict = function () {
      $.fn.Spotlight = old
      return this
    }
  
   /* Spotlight DATA-API
    * ================= */
    $(document).ready('ready','.spotlight',function(){
	    
	    console.log(this);
	    
    });
    $(document).on('click.spotlight.data-api', '[data-spotlight-slide], [data-spotlight-slide-to]', function (e) {
      var $this = $(this), href
        , $target = $($this.attr('data-target') || (href = $this.attr('href')) && href.replace(/.*(?=#[^\s]+$)/, '')) //strip for ie7
        , options = $.extend({}, $target.data(), $this.data())
        , slideIndex
	
      $target.Spotlight(options)
	 
      if (slideIndex = $this.attr('data-spotlight-slide-to')) {
        $target.data('Spotlight').pause().to(slideIndex).cycle()
      }
  
      e.preventDefault()
    })
  
  }(jQuery);
})()