require 'spec_helper'

describe CustomerConsole::Application do
  context "routing" do
    it "routes product click throughs" do
      expect(get: "/products/100/redirection").to route_to(
        controller: "products",
        action: "redirection",
        id: "100"
      )
    end

    it "routes centre scoped product click throughs" do
      expect(get: "/bondijunction/products/100/redirection").to route_to(
        controller: "products",
        action: "redirection",
        id: "100",
        centre_id: "bondijunction"
      )
    end

    context "for /products" do
      let(:base_params) { { controller: "products", action: "index" } }
      it "routes to product browse" do
        expect(get: "/products").to route_to(base_params)
      end

      it "routes with super_cat" do
        expect(get: "/products/womens-fashion").to route_to(base_params.merge(super_cat: 'womens-fashion'))
      end

      it "routes with category" do
        expect(get: "/products/womens-fashion/shoes").to route_to(base_params.merge({
          super_cat: 'womens-fashion',
          category: 'shoes'
        }))
      end

      it "routes to a product" do
        expect(get: "/products/runway-fashionz/sparkle-top/100").to route_to(base_params.merge({
          action: 'show',
          retailer_code: 'runway-fashionz',
          product_name: 'sparkle-top',
          id: '100'
        }))
      end
    end

    context "for :centre/products" do
      let(:base_params) { { controller: "products", action: "index", centre_id: "bondijunction" } }
      it "routes centre scoped product browse" do
        expect(get: "/bondijunction/products").to route_to(base_params)
      end

      it "routes with super_cat" do
        expect(get: "/bondijunction/products/womens-fashion").to route_to(base_params.merge(super_cat: 'womens-fashion'))
      end

      it "routes with category" do
        expect(get: "/bondijunction/products/womens-fashion/shoes").to route_to(base_params.merge({
          super_cat: 'womens-fashion',
          category: 'shoes'
        }))
      end

      it "routes to a product" do
        expect(get: "/bondijunction/products/runway-fashionz/sparkle-top/100").to route_to(base_params.merge({
          action: 'show',
          retailer_code: 'runway-fashionz',
          product_name: 'sparkle-top',
          id: '100'
        }))
      end
    end
  end
end