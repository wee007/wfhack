#= require jquery-extensions/jquery.fastLiveFilter


$ =>

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


  $('.js-store-hours-keyword-filter-input').fastLiveFilter '.js-store-list',
    selector: 'li',
    # Need a small timeout because of race condition on mobile
    filterFunction: filterStores
    callback: (stores, numShown)=>
      console.log(stores, numShown)
      #@filterStoreLetterHeadings(stores, numShown)
      #@handleNoStoresInList(numShown)
      #@updateNumberOfFilteredStores(numShown)
      #@callback()