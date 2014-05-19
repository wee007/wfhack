require 'spec_helper'

describe ProductsHelper do

  describe :noscript_category_canonical_url do

    describe "on [ national ] products page" do

      context "when super category is present" do
        let(:search) do
          Hashie::Mash.new(
            categories: [
              Hashie::Mash.new(
                url_args:
                  Hashie::Mash.new(
                    super_cat: 'super_category'
                  )
              )
            ]
          )
        end
        let(:categories) { search.categories.first.url_args }

        subject { helper.noscript_category_canonical_url(categories) }

        it "returns the canonical URL for super category" do
          expect(subject).to eq('http://test.host/products/super_category')
        end
      end

      context "when category is present" do
        let(:search) do
          Hashie::Mash.new(
            categories: [
              Hashie::Mash.new(
                url_args:
                  Hashie::Mash.new(
                    category: 'category',
                    super_cat: 'super_category'
                  )
              )
            ]
          )
        end
        let(:categories) { search.categories.first.url_args }

        subject { helper.noscript_category_canonical_url(categories) }

        it "returns the canonical URL for category" do
          expect(subject).to eq('http://test.host/products/super_category/category')
        end
      end

      context "when subcategory is present" do
        let(:search) do
          Hashie::Mash.new(
            categories: [
              Hashie::Mash.new(
                url_args:
                  Hashie::Mash.new(
                    sub_category: 'sub_category'
                  )
              )
            ]
          )
        end
        let(:categories) { search.categories.first.url_args }
        let(:canonical_url) { "http://test.host/products/super_category/category?sub_category=#{categories.sub_category}" }

        subject { helper.noscript_category_canonical_url(categories) }

        it "returns the canonical URL for sub_category" do
          helper.stub(:url_for).with({params: {'sub_category' => 'sub_category'}}).and_return(canonical_url)
          expect(subject).to eq(canonical_url)
        end
      end

    end

  end

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