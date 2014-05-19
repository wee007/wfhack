$ ->
  $.get("/search-xhr?centre=#{westfield.centre_id}&search_query="+westfield.search_query).then (html) ->
    $('.js-product-results-container').html(html)
    numberOfProducts = $(html).find(".js-tile").length
    $(".js-product-result-count").text (i, oldhtml) ->
      parseInt(oldhtml, 10) + numberOfProducts