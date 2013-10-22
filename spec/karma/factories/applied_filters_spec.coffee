'use strict'

describe 'Factory format filters: AppliedFilters',  ->
  beforeEach module('Westfield')
  AppliedFilters = null

  testObject =
    facets:
      centre:
        type: 'centre'
        selected_values: [
          {
            value: 'bondijunction'
            title: 'Bondi Junction'
          }
        ]
      search_query:
        type: 'search_query'
        selected_values:
          value: 'hard drive'
      retailer:
        type: 'retailer'
        selected_values: [
          {
            value: 'jb-hi-fi'
            title: 'JB HiFi'
          }
        ]
        title: 'Retailer'
    categories:
      [
        type: 'super_cat'
        value: 'womens-fashion'
        title: 'Womens Fashion'
      ]


  beforeEach inject (_AppliedFilters_) ->
    AppliedFilters = _AppliedFilters_

  it 'does something', ->
    expect(!!AppliedFilters.format).toBe true

  it 'returns a list of active filters', ->
    expect(AppliedFilters.format(testObject)).toEqual([
      {
        type: 'search_query'
        title: '"hard drive"'
        value: 'hard drive'
      },
      {
        type: 'retailer'
        title: 'JB HiFi'
        value: 'jb-hi-fi'
      },
      {
        type: 'super_cat'
        title: 'Womens Fashion'
        value: 'womens-fashion'
      }
    ])
