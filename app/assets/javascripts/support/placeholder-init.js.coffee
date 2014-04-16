class @PlaceholderPolyfill
  constructor: ->
    # Apply it straight away
    @applyPlaceholderPolyfill()

    # Apply it after pager load
    window.addEventListener('load', @applyPlaceholderPolyfill)

    # Apply it after something changed on products page, ie the filter DOM is refereshed
    $(document).on('products.change', @applyPlaceholderPolyfill)

  applyPlaceholderPolyfill: ->
    setTimeout ->
      $('input, textarea').placeholder();
    , 0

new PlaceholderPolyfill()