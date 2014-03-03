require 'spec_helper'

describe ProductsHelper do

  describe :category_canonical_url do

    describe "on [ national ] product detail page" do

      context "when super category is present" do
        let(:product) do
          Hashie::Mash.new(
            category_hierarchy: [
              Hashie::Mash.new(
                name: 'Super Category',
                code: 'super_category'
              )
            ]
          )
        end
        let(:category_count) { 0 }

        it "returns the super category URL" do
          assign(:product, product)
          expect(helper.category_canonical_url(category_count)).to eq("http://test.host/products/super_category")
        end
      end

      context "when category is present" do
        let(:product) do
          Hashie::Mash.new(
            category_hierarchy: [
              Hashie::Mash.new(
                name: 'Super Category',
                code: 'super_category'
              ),
              Hashie::Mash.new(
                name: 'Category',
                code: 'category'
              )
            ]
          )
        end
        let(:category_count) { 1 }

        it "returns the category URL" do
          assign(:product, product)
          expect(helper.category_canonical_url(category_count)).to eq("http://test.host/products/super_category/category")
        end
      end

      context "when subcategory is present" do
        let(:product) do
          Hashie::Mash.new(
            category_hierarchy: [
              Hashie::Mash.new(
                name: 'Super Category',
                code: 'super_category'
              ),
              Hashie::Mash.new(
                name: 'Category',
                code: 'category'
              ),
              Hashie::Mash.new(
                name: 'Subcategory',
                code: 'sub_category'
              )
            ]
          )
        end
        let(:category_count) { 2 }

        it "returns the subcategory URL" do
          assign(:product, product)
          expect(helper.category_canonical_url(category_count)).to eq("http://test.host/products/super_category/category?sub_category=sub_category")
        end
      end

    end


    describe "on [ centre ] product detail page" do

      before :each do
        assign(:centre, 'sydney')
      end

      context "when super category is present" do
        let(:product) do
          Hashie::Mash.new(
            category_hierarchy: [
              Hashie::Mash.new(
                name: 'Super Category',
                code: 'super_category'
              )
            ]
          )
        end
        let(:category_count) { 0 }

        it "returns the super category URL" do
          assign(:product, product)
          expect(helper.category_canonical_url(category_count)).to eq("http://test.host/sydney/products/super_category")
        end
      end

      context "when category is present" do
        let(:product) do
          Hashie::Mash.new(
            category_hierarchy: [
              Hashie::Mash.new(
                name: 'Super Category',
                code: 'super_category'
              ),
              Hashie::Mash.new(
                name: 'Category',
                code: 'category'
              )
            ]
          )
        end
        let(:category_count) { 1 }

        it "returns the category URL" do
          assign(:product, product)
          expect(helper.category_canonical_url(category_count)).to eq("http://test.host/sydney/products/super_category/category")
        end
      end

      context "when subcategory is present" do
        let(:product) do
          Hashie::Mash.new(
            category_hierarchy: [
              Hashie::Mash.new(
                name: 'Super Category',
                code: 'super_category'
              ),
              Hashie::Mash.new(
                name: 'Category',
                code: 'category'
              ),
              Hashie::Mash.new(
                name: 'Subcategory',
                code: 'sub_category'
              )
            ]
          )
        end
        let(:category_count) { 2 }

        it "returns the subcategory URL" do
          assign(:product, product)
          expect(helper.category_canonical_url(category_count)).to eq("http://test.host/sydney/products/super_category/category?sub_category=sub_category")
        end
      end
    end

  end

  describe :retailer_canonical_url do

    describe "on [ national ] product detail page" do

      context "when retailer is present" do
        let(:product) do
          Hashie::Mash.new(
            retailer_code: 'retailer_code',
            retail_chain_name: 'Retail Chain Name'
          )
        end

        it "returns the super category URL" do
          assign(:product, product)
          expect(helper.retailer_canonical_url).to eq("http://test.host/products?retailer=retailer_code")
        end
      end

    end

    describe "on [ centre ] product detail page" do

      context "when retailer is present" do
        let(:product) do
          Hashie::Mash.new(
            retailer_code: 'retailer_code',
            retail_chain_name: 'Retail Chain Name'
          )
        end

        it "returns the super category URL" do
          assign(:centre, 'sydney')
          assign(:product, product)
          expect(helper.retailer_canonical_url).to eq("http://test.host/sydney/products?retailer=retailer_code")
        end
      end

    end

  end

end