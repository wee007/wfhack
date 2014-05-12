class @StoresPageState
  constructor: ->
    doc = $(document)
    doc.on 'change', '.js-stores-gift-card-toggle', (event) =>
      element = event.target
      @setGiftCardState(element)
      @triggerFormSubmit(element)

    doc.on 'click', '.js-stores-page-state-params', @setFilteredCategoryState

    doc.on 'submit', '.js-stores-clear-filtered-category', @clearFilteredCategoryState

  setGiftCardState: (element) ->
    sessionStorage.giftCards = element.checked

  triggerFormSubmit: (element) ->
    form = $(element).closest('form')
    form.trigger('submit')

  setFilteredCategoryState: (event) ->
    sessionStorage.filteredCategory = $(event.target).data('category')

  clearFilteredCategoryState: ->
    sessionStorage.removeItem('filteredCategory')