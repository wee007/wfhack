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

  let(:results) {
    [
      Hashie::Mash.new(
        result_type: 'store',
        attributes: {
          category: false
        }
      ),
      Hashie::Mash.new(
        result_type: 'product_category',
        attributes: {
          category: true
        }
      )
    ]
  }

  describe "#has_result_type" do
    context "When checking the result type" do
      it "should be true when we have a store result" do
        expect(helper.has_result_type?(results, "store")).to be_true
      end
      it "should be true when we have a product_category result" do
        expect(helper.has_result_type?(results, "product_category")).to be_true
      end
    end
  end

  describe "#has_category_results" do
    context "When checking if one or more of the results is a category" do
      it "should be true when we have a category result" do
        expect(helper.has_category_results?(results)).to be_true
      end
    end
  end

  describe "#results_by_type" do
    let(:filtered_results) {
      [
        Hashie::Mash.new(
          result_type: 'store',
          attributes: {
            category: false
          }
        )
      ]
    }
    context "When filtering results by type" do
      it "should only contain store results" do
        expect(helper.results_by_type(results, "store")).to eql(filtered_results)
      end
    end
  end

  describe "#number_of_results" do
    context "When counting the number of results" do
      it "should return 2 results" do
        expect(helper.number_of_results(results)).to eql(2)
      end
    end
  end

end