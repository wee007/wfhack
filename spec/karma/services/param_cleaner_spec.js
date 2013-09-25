'use strict';

describe('Service: ParamCleaner', function () {

  // load the service's module
  beforeEach(module('Westfield'));

  // instantiate service
  var ParamCleaner;
  beforeEach(inject(function (_ParamCleaner_) {
    ParamCleaner = _ParamCleaner_;
  }));

  it('should do something', function () {
    expect(!!ParamCleaner.build).toBe(true);
  });

  it('will not change the original object', function () {
    var original = {key: ['value']},
        clean_params = ParamCleaner.build(original);

    expect(original).toEqual({key: ['value']});
    expect(clean_params).toEqual({'key[]': ['value']});
  });

  it('removes empty array values', function () {
    expect(ParamCleaner.build({empty:[]})).toEqual({});
  });

  it('removes false booleans', function () {
    expect(ParamCleaner.build({bool:false})).toEqual({});
  });

  it('converts arrays to use key[]', function (){
    expect(ParamCleaner.build({a: [1, 2, 3]})).toEqual({'a[]': [1, 2, 3]});
  });

  it('does not convert keys that already use [] notation', function() {
    expect(ParamCleaner.build({'a[]': [1, 2, 3]})).toEqual({'a[]': [1, 2, 3]});
  });

  it('removes centre if it equals products', function () {
    expect(ParamCleaner.build({'centre': 'products'})).toEqual({});
    expect(ParamCleaner.build({'centre': 'not-products'})).toEqual({'centre': 'not-products'});
  })

  it('removes the [] notation from a key', function () {
    expect(ParamCleaner.deserialize({'key[]': 'value'})).toEqual({'key': 'value'});
  });
});
