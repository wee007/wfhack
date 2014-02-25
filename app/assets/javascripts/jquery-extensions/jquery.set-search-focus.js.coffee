# Focus in the global search input when it's opened via the toggle trigger
@setSearchFocus = ->
  $(".js-search-toggle").click ->
    target = $(this).attr('toggle-visibility')
    searchInput = $("##{target} input[type=\"search\"]")
    if $("##{target}").hasClass('is-active')
      searchInput.focus()
    else
      searchInput.blur()