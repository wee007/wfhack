'use strict';

describe('Service: SuggestionsBuilder', function () {

  // load the service's module
  beforeEach(module('Westfield'));

  // instantiate service
  var SuggestionsBuilder;
  beforeEach(inject(function (_SuggestionsBuilder_) {
    SuggestionsBuilder = _SuggestionsBuilder_;
  }));

  describe('to_sentence', function() {
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

  describe('remainingWords', function() {
    it('returns empty string if one given', function () {
      expect(SuggestionsBuilder.remainingWords('',[])).toBe("");
    });
    it('returns empty string if all words match', function () {
      expect(SuggestionsBuilder.remainingWords('red',[{'red':'Reds'}])).toBe("");
    });
    it('returns empty string if more than all words match', function () {
      expect(SuggestionsBuilder.remainingWords('',[{'red':'Reds'}])).toBe("");
    });
    it("returns empty string if all words match and it's long", function () {
      expect(SuggestionsBuilder.remainingWords('red yellow blue',[{'red':'Reds'},{'yellow':'Yellows'},{'blue':'Blues'}])).toBe("");
    });
    it("returns the remaining words concatenated if some words match", function () {
      expect(SuggestionsBuilder.remainingWords('zomg red fhqwhgads yellow blooper blue bananas',[{'red':'Reds'},{'yellow':'Yellows'},{'blue':'Blues'}])).toBe("zomg fhqwhgads blooper bananas");
    });
    it("returns all words concatenated if nothing matches", function () {
      expect(SuggestionsBuilder.remainingWords('zomg red fhqwhgads yellow blooper blue bananas',[])).toBe("zomg red fhqwhgads yellow blooper blue bananas");
    });
  });

});
