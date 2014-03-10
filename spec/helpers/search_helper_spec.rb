require 'spec_helper'

describe SearchHelper do

  context :build_url do
    describe "When building a url" do
      before(:each) do
        attributes = Hashie::Mash.new(
          id: 123
        )
        @url = helper.build_url('bondijunction', 'events', attributes)
      end
      it "should build it according to the attributes" do
        expect(@url).to eql('/bondijunction/events/123')
      end
    end
    describe "When a url is provided" do
      before(:each) do
        attributes = Hashie::Mash.new(
          path: '/bondijunction/hours'
        )
        @url = helper.build_url('bondijunction', 'centre_information', attributes)
      end
      it "should return that url" do
        expect(@url).to eql('/bondijunction/hours')
      end
    end
    describe "When products with a centre" do
      before(:each) do
        attributes = Hashie::Mash.new(
          category: "womens-dresses",
          super_cat: "womens-fashion-accessories"
        )
        @url = helper.build_url('bondijunction', 'products', attributes)
      end
      it "should return the centre url" do
        expect(@url).to eql('/bondijunction/products/womens-fashion-accessories/womens-dresses')
      end
    end
    describe "When products without a centre" do
      before(:each) do
        attributes = Hashie::Mash.new(
          category: "womens-dresses",
          super_cat: "womens-fashion-accessories"
        )
        @url = helper.build_url(nil, 'products', attributes)
      end
      it "should return the national url" do
        expect(@url).to eql('/products/womens-fashion-accessories/womens-dresses')
      end
    end
  end

end