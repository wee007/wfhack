$ ->
  $(document).on 'click', '.js-stores-view-subcategories', ->
    id = $(@).attr('id')
    $(".js-stores-category-#{id}").addClass('is-active')