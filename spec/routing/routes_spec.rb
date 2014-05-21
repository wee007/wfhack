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
      let(:base_params) { { controller: "products", action: "index_national" } }

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
          action: 'show_national',
          retailer_code: 'runway-fashionz',
          product_name: 'sparkle-top',
          id: '100'
        }))
      end

      describe '/products/collection/:slug' do
        let(:slug) { 'red-socks' }
        subject {{ get: "products/collection/#{slug}" }}
        it { should route_to Hash controller: 'curations', action: 'show', centre_id: nil, slug: slug }
      end
    end

    context "for :centre/products" do
      let(:base_params) { { controller: "products", action: "index_centre", centre_id: "bondijunction" } }

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
          action: 'show_centre',
          retailer_code: 'runway-fashionz',
          product_name: 'sparkle-top',
          id: '100'
        }))
      end

      describe ':centre_id/products/collection/:slug' do
        let(:slug) { 'red-socks' }
        let(:centre_id) { 'bondijunction' }
        subject {{ get: "#{centre_id}/products/collection/#{slug}" }}
        it { should route_to Hash[ controller: 'curations', action: 'show', centre_id: centre_id, slug: slug ]}
      end
    end

    context "for social shares" do
      let(:base_params) { { controller: "social_shares", action: "show", id: "1" } }

      it "routes to product" do
        expect(get: "/products/1/social-share").to route_to(base_params.merge({"kind"=>"product"}))
      end

      context "in a centre" do

        let(:base_params) { { controller: "social_shares", action: "show", id: "1", centre_id: 'bondijunction'} }

        it "routes to a product" do
          expect(get: "/bondijunction/products/1/social-share").to route_to(base_params.merge({"kind"=>"product"}))
        end

        it "routes to a deal" do
          expect(get: "/bondijunction/deals/1/social-share").to route_to(base_params.merge({"kind"=>"deal"}))
        end

        it "routes to a event" do
          expect(get: "/bondijunction/events/1/social-share").to route_to(base_params.merge({"kind"=>"event"}))
        end

        it "routes to a movie" do
          expect(get: "/bondijunction/movies/1/social-share").to route_to(base_params.merge({"kind"=>"movie"}))
        end

        it "routes to a notice" do
          expect(get: "/bondijunction/notices/1/social-share").to route_to(base_params.merge({"kind"=>"centre_service_notice"}))
        end

        it "routes to a canned search" do
          expect(get: "/bondijunction/canned-searches/1/social-share").to route_to(base_params.merge({"kind"=>"canned_search"}))
        end

        it 'routes to a curation' do
          expect(get: "/bondijunction/products/curation/1/social-share").to route_to(base_params.merge({ 'kind'=>'curation' }))
        end
      end
    end

    describe "for :centres/deals" do
      let(:route) {{ controller: 'deals', centre_id: 'bondijunction' }}
      it "routes centre deals" do
        expect(get: '/bondijunction/deals').to route_to route.merge action: 'index'
      end

      it "routes retailer deals" do
        retailer_deal_route = { retailer_code: 'saba', id: '666', action: 'show' }
        expect(get: '/bondijunction/deals/saba/666').to route_to route.merge retailer_deal_route
      end

      it 'routes campaigns' do
        campaign_route = { campaign_code: 'back-to-school', action: 'index'}
        expect(get: '/bondijunction/deals/back-to-school').to route_to route.merge campaign_route
      end
    end
  end
end
