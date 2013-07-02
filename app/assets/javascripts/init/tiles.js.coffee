$(window).load ->
  $('#pin-board').isotope(
    itemSelector : '.tile',
    autoGutters: true,
    containerStyle: {
      position: 'relative',
      overflow: 'visible'
    }
  )