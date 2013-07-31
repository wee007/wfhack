'use strict';

describe('Service: SuggestionsBuilder', function () {

  // load the service's module
  beforeEach(module('Westfield'));

  // instantiate service
  var SuggestionsBuilder;
  beforeEach(inject(function (_SuggestionsBuilder_) {
    SuggestionsBuilder = _SuggestionsBuilder_;
  }));

  it('garbage in garbage out', function () {
    expect(SuggestionsBuilder.to_sentence([], null, 'or')).toBe("");
  });
  it('displays single items as they are', function () {
    expect(SuggestionsBuilder.to_sentence(['red'], null, 'or')).toBe("red");
  });
  it('joins 2 items with the conjunction', function () {
    expect(SuggestionsBuilder.to_sentence(['red', 'blue'], null, 'or')).toBe("red or blue");
  });
  it('joins 3 items with commas then the conjunction', function () {
    expect(SuggestionsBuilder.to_sentence(['red', 'yellow', 'blue'], null, 'or')).toBe("red, yellow or blue");
  });
  it('works with hashes', function () {
    expect(SuggestionsBuilder.to_sentence([{'foo':'red'}, {'foo':'yellow'}, {'foo':'blue'}], 'foo', 'or')).toBe("red, yellow or blue");
  });
  it('discards duplicates', function () {
    expect(SuggestionsBuilder.to_sentence([{'foo':'red'}, {'foo':'red'}, {'foo':'yellow'}, {'foo':'blue'}], 'foo', 'or')).toBe("red, yellow or blue");
  });

});
