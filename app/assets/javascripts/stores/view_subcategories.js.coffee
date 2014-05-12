$ ->
  activeCategory = ''
  toggleSubCategory = (showSubCategory) ->
    $(".js-stores-category-#{activeCategory}")
      .toggleClass('is-active', showSubCategory)
      .attr('aria-hidden', !showSubCategory)

    $('.js-stores-categories')
      .toggleClass('is-active', !showSubCategory)


  doc.on 'click', '.js-stores-view-subcategories', ->
    activeCategory = $(@).attr('id')
    toggleSubCategory(true)

  doc.on 'click', '.js-stores-hide-subcategories', ->
    toggleSubCategory(false)

  doc.on 'toggle-visibility.hide', '.js-stores-category-btn', ->
    toggleSubCategory(false)

  $('.js-stores-view-subcategories').each (i, el) ->
    category = $(@).attr('id')
    $(@).attr
      'aria-controls': "#{category}_categories"
      'aria-haspopup': true
      'aria-hidden': true
    $(".js-stores-category-#{category}").attr('aria-labelledby', category)





