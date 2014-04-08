class @PlaceholderPolyfill
  constructor: ->
    window.addEventListener "load", @applyPlaceholderPolyfill
    $(document).on("products.change", @applyPlaceholderPolyfill)

  applyPlaceholderPolyfill: ->
    setTimeout ->
      $('input, textarea').placeholder();
    , 0

new PlaceholderPolyfill()