require 'spec_helper'

describe RetailerCategoriesDecorator do
  include Draper::ViewHelpers
  let(:data_child) { Hashie::Mash.new(code: 'cat2') }
  let(:data) { [Hashie::Mash.new(children: [data_child], code: 'cat1')] }

  context "get" do
    subject { RetailerCategoriesDecorator.decorate(data).get 'cat2' }
    it { should eql data_child }
  end

  context "with_children" do
    subject { RetailerCategoriesDecorator.decorate(data).with_children }
    it { should eql data }
  end

end
