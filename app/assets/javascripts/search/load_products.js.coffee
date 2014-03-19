$ ->
  $('.js-product-results').load('/products-xhr?rows=5')
  $('.js-product-results-container').removeClass('hide-fully')