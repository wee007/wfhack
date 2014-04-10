$ ->
  activeCategory = ''
  toggleSubCategory = (showSubCategory) ->
    $(".js-stores-category-#{activeCategory}").toggleClass('is-active', showSubCategory)
    $(".js-stores-categories").toggleClass('is-active', !showSubCategory)

  $(document).on 'click', '.js-stores-view-subcategories', ->
    activeCategory = $(@).attr('id')
    toggleSubCategory(true)

  $(document).on 'click', '.js-stores-hide-subcategories', ->
    toggleSubCategory(false)

