$ ->
    $.get('/search-xhr?search_query='+westfield.search_query).then (html) ->
      $('.js-product-results').html(html)
      $('.js-product-results-container').removeClass('hide-fully')
      numberOfProducts = $(html).find(".js-tile").length
      $(".js-product-result-count").text (i, oldhtml) ->
        parseInt(oldhtml, 10) + numberOfProducts