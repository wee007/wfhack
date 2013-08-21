do (window, $ = jQuery) ->
  init = ->
    $("#pin-board").isotope
      containerClass: '.pin-board'
      itemSelector: ".tile"
      widthFix: true
      responsive:
        maxNumberOfColumn: 5
        minNumberOfColumn: 2
        minItemSize: 200
        gutter: 10
      containerStyle:
        position: "relative"
        overflow: "visible"

  $(window).on 'load', init
