'use strict';

describe('Factory: SearchFacet', function () {

  // load the service's module
  beforeEach(module('Westfield'));

  // instantiate service
  var SearchFacet;
  beforeEach(inject(function (_SearchFacet_) {
    SearchFacet = _SearchFacet_;
  }));

  var testObject = [
    {
      field: 'price',
      title: 'Price range',
      min: 0,
      max: 10000
    },
    {
      field: 'brand',
      title: 'Brands',
      values: [
        {
          name: 'Nike',
          code: 'nike',
          count: 125
        }
      ]
    }
  ];

  it('should do something', function () {
    expect(!!SearchFacet.retrieve).toBe(true);
  });

  it('returns a single value facet', function () {
    expect(SearchFacet.retrieve(testObject, 'price')).toEqual({
      field: 'price',
      title: 'Price range',
      values: {
        field: 'price',
        title: 'Price range',
        min: 0,
        max: 10000
      }
    });
  });

  it('returns the multi-value facet', function () {
    expect(SearchFacet.retrieve(testObject, 'brand')).toEqual({
      field: 'brand',
      title: 'Brands',
      values: [
        {
          name: 'Nike',
          code: 'nike',
          count: 125
        }
      ]
    });
  });
});
