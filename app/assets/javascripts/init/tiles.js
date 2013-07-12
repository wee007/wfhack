(function ( window, $ ) {
  var init = function () {
    $( '#pin-board' ).isotope({
      itemSelector : '.tile',
      autoGutters: true,
      containerStyle: {
        position: 'relative',
        overflow: 'visible'
      }
    });
  };

  window.initPlugin = window.initPlugin || {};
  window.initPlugin.isotope = init;
  $( window ).load( init );
} ( this, jQuery ) );