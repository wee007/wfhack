@viewportCheck = ->
  setTimeout ->
    $('.js-viewport-check:in-viewport').addClass 'is-in-viewport'
  , 0

# Check the view port onload
viewportCheck()

# Check the viewport onscroll
$(window).scroll viewportCheck

# Check the view port on click EG: tabs
$('.js-viewport-check-on-click').click viewportCheck