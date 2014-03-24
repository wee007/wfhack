$ ->
  $.get("/search-xhr?centre=#{westfield.centre}&search_query="+westfield.search_query).then (html) ->
    $('.js-product-results-container').html(html).removeClass('hide-fully')
    $('.js-product-results-hdr').removeClass('hide-fully')
    numberOfProducts = $(html).find(".js-tile").length
    $(".js-product-result-count").text (i, oldhtml) ->
      parseInt(oldhtml, 10) + numberOfProducts