require 'spec_helper'

describe FilteredStoresDecorator do
  include Draper::ViewHelpers

  let(:stores) do
    [
      Store.new(accepts_giftcards: false, name: 'Store two', category_codes: ['cat1']),
      Store.new(accepts_giftcards: true, name: 'Store one', category_codes: ['cat2']),
      Store.new(accepts_giftcards: true, name: 'Store three', category_codes: ['cat3']),
    ]
  end

  let(:cat1) { Hashie::Mash.new code: "cat1", children: [cat2] }
  let(:cat2) { Hashie::Mash.new code: "cat2", children: [] }
  let(:cat3) { Hashie::Mash.new code: "cat3", children: [] }

  before(:each) do
    RetailerCategoryService.stub(:find).and_return [cat3, cat1]
  end

  context :any_accepting_gift_cards do
    subject { FilteredStoresDecorator.decorate(stores).any_accepting_gift_cards? }
    it { should be_true }
  end

  context :in_alpha_groups do
    subject { FilteredStoresDecorator.decorate(stores).in_alpha_groups }
    it { should eql({'S' => stores}) }
  end

  context :sorted_categories do
    subject { FilteredStoresDecorator.decorate(stores).sorted_categories }
    it { should eql [cat1, cat3] }
  end

  context :categories do
    subject { FilteredStoresDecorator.decorate(stores).categories }
    it { should eql [cat3, cat1] }
  end

end
