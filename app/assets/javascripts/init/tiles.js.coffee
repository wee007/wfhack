((window, $) ->
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

  window.initPlugin = window.initPlugin or {}
  window.initPlugin.isotope = init
  $(window).load init
) this, jQuery