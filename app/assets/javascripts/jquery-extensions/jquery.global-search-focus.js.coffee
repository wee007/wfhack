# Focus in the global search input when it's opened via the toggle trigger
@globalSearchFocus = ->
  $(".js-global-search-toggle").click ->
    globalSearchInput = $(".js-global-search input[type=\"search\"]")
    if $(".js-global-search.is-active").length
      globalSearchInput.focus()
    else
      globalSearchInput.blur()