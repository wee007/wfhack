#= require jquery-extensions/jquery.fastLiveFilter

$ =>

  noStoresMatchingMessage = $('.js-store-hours-keyword-filter-no-results')
  storeListLetters = $('.js-store-hours-keyword-filter-letter')

  # Determines how stores will be matched with keyword
  filterStores = (filter, fullText) =>
    matches = false
    if filter.length == 1
      return fullText.substr(0, 1) == filter

    if filter.indexOf(' ') >= 0
      return fullText.indexOf(filter) == 0

    $.each fullText.split(' '), (i, word) ->
      if word.indexOf(filter) == 0
        matches = true

    return matches

  filterStoreLetterHeadings = (stores, numShown) =>
    firstLetter = ''
    visibleLetterHeadings = []
    previousFirstLetter = ''

    $.each stores, (i, store)->
      if not store.hidden
        firstLetter = store.text.substr(0, 1).toLowerCase()
        if not isNaN firstLetter
          firstLetter = '#'

        if previousFirstLetter isnt firstLetter
          visibleLetterHeadings.push(firstLetter)
          previousFirstLetter = firstLetter

    storeListLetters.each (i, el) ->
      heading = $(el)
      letter = $.trim(heading.text()).toLowerCase()
      if letter in visibleLetterHeadings
        heading.removeClass('hide-fully')
      else
        heading.addClass('hide-fully')


  handleNoStoresInList = (numShown) =>
    if numShown == 0
      noStoresMatchingMessage.removeClass('hide-fully')
      noStoresMatchingMessage.find('.js-store-hours-keyword-filter-value').html('\"'+$('.js-store-hours-keyword-filter-input').val()+'\"')
    else
      noStoresMatchingMessage.addClass('hide-fully')

  $('.js-store-hours-keyword-filter-input').fastLiveFilter '.js-store-hours-store-list',
    selector: '.js-store-hours-store-name',
    filterFunction: filterStores
    callback: (stores, numShown) =>
      filterStoreLetterHeadings(stores, numShown)
      handleNoStoresInList(numShown)
