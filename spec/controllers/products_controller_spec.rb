require 'spec_helper'

describe ProductsController do

  before :each do
    StoreService.stub(:fetch)
    CentreService.stub(:fetch).and_return double :response, body: {}
    CentreService.stub(:group_by_state)
    ProductService.stub(:fetch).and_return double( :response,
      body: {
        details: [],
        name: "test_product",
        retail_chain_name: "product_rcn",
        primary_retailer_product_url: "http://www.prp_url.com",
        retail_chain: {cam_ref: nil, name: "product_rcn"},
        categories: [{super_category: {code: "spec_test"}}]
      },

      facets: [
        Hashie::Mash.new({ field: 'super_cat', values: [] })
      ]
    )
  end

  describe "GET #index" do
    before :each do
      CentreService.stub(:fetch).and_return double :response, body: { name: 'Westfield Bondi Junction' }
      object = Hashie::Mash.new(count: 50, rows: 50, facets: [{'values' => [], 'field' => 'super_cat'}])
      ProductService.stub(:build).and_return object
    end

    it "assigns the centre instance variable" do
      get :index, centre_id: 'bondijunction'
      response.should render_template :index
      assigns(:centre).should_not be_nil
    end

    it "does not assign the centre instance variable" do
      get :index
      response.should render_template :index
      assigns(:centre).should be_nil
    end

    context "when requesting for page title and meta description" do
      it "adds page title and meta description to meta" do
        meta_double = double :meta
        meta_double.should_receive(:push).with({
          page_title: "Shopping at Westfield Bondi Junction",
          description: "Find the latest fashion, clothes, shoes, jewellery, accessories and much more at Westfield Bondi Junction"
        })
        controller.stub(:meta).and_return(meta_double)
        get :index, centre_id: 'bondijunction'
      end
    end

    context "when requesting for page title and meta description for given sub-category" do
      it "adds page title and meta description to meta" do
        meta_double = double :meta
        meta_double.should_receive(:push).with({
          page_title: "Buy Product 2 online at Westfield Bondi Junction",
          description: "Browse the latest Product 2 online at Westfield Bondi Junction"
        })
        controller.stub(:meta).and_return(meta_double)
        get :index, centre_id: 'bondijunction', sub_category: ['product-2'], category: 'product-1'
      end
    end

    context "when requesting for page title and meta description for given sub-categories" do
      it "adds page title and meta description to meta" do
        meta_double = double :meta
        meta_double.should_receive(:push).with({
          page_title: "Buy Product 2 and Product 3 online at Westfield Bondi Junction",
          description: "Browse the latest Product 2 and Product 3 online at Westfield Bondi Junction"
        })
        controller.stub(:meta).and_return(meta_double)
        get :index, centre_id: 'bondijunction', sub_category: ['product-2','product-3'], category: 'product-1'
      end
    end

    context "when requesting for page title and meta description for given category" do
      it "adds page title and meta description to meta" do
        meta_double = double :meta
        meta_double.should_receive(:push).with({
          page_title: "Buy Product online at Westfield Bondi Junction",
          description: "Browse the latest Product online at Westfield Bondi Junction"
        })
        controller.stub(:meta).and_return(meta_double)
        get :index, centre_id: 'bondijunction', category: 'product'
      end
    end
  end

  describe "GET #show" do
    it "does not assign the centre instance variable" do
      get :show, id: 1, centre_id: 'bondijunction'
      response.should render_template :show
      assigns(:centre).should_not be_nil
    end

    it "assigns the centre instance variable" do
      get :show, id: 1
      response.should render_template :show
      assigns(:centre).should be_nil
    end

    context "when cam_ref is missing" do
      it "assigns retailer url" do
        get :show, id: 1
        assigns(:product_redirection_url).should ==
          product_redirection_url + "?pn=test_product&ptu=http%3A%2F%2Fwww.prp_url.com&rcn=product_rcn"
      end
    end

    context "when cam_ref exists" do
      before :each do
        ProductService.stub(:fetch).and_return double( :response,
          body: {
            details: [],
            name: "test_product",
            retail_chain_name: "product_rcn",
            primary_retailer_product_url: "http://www.prp_url.com",
            retail_chain: {cam_ref: "1234", name: "product_rcn"},
            categories: [{super_category: {code: "spec_test"}}]
          }
        )
      end

      it "assigns tracking url" do
        @request.env['REMOTE_ADDR'] = '1.2.3.4'
        get :show, id: 1, centre_id: 'bondijunction', utm_source: "googleshopping",
          utm_medium: "affiliate", utm_keyword: "dresses", utm_campaign: "xyz"

        assigns(:product_redirection_url).should == centre_product_redirection_url +
         "?pn=test_product&ptu=http%3A%2F%2Fprf.hn%2Fclick%2Fcamref%3A1234%2F" \
         "pubref%3Ahttp%3A%2F%2Ftest.host%2Fbondijunction%2Fproducts%2F1%3F" \
         "utm_campaign%3Dxyz%26utm_keyword%3Ddresses%26utm_medium%3Daffiliate%26" \
         "utm_source%3Dgoogleshopping%257C1.2.3.4%257Cexpression%257Cgoogleshopping" \
         "%257Caffiliate%257Cdresses%2Fadref%3Aspec_test%2F" \
         "destination%3Ahttp%3A%2F%2Fwww.prp_url.com&rcn=product_rcn"
      end
    end
  end


  describe "GET #redirection" do
    it "assigns proper data from url to meta" do
      @request.env['REMOTE_ADDR'] = '1.2.3.4'
      meta_double = double :meta
      meta_double.should_receive(:push).with({
        retail_chain_name: "product_rcn",
        page_title: "product_rcn - test_product",
        product_tracking_url: "http%3A%2F%2Fprf.hn%2Fclick%2Fcamref%3A1234%2F" \
         "pubref%3Ahttp%3A%2F%2Ftest.host%2Fbondijunction%2Fproducts%2F1%3F" \
         "utm_campaign%3Dxyz%26utm_keyword%3Ddresses%26utm_medium%3Daffiliate%26" \
         "utm_source%3Dgoogleshopping%7C1.2.3.4%7Cexpression%7Cgoogleshopping" \
         "%7Caffiliate%7Cdresses%2Fadref%3Aspec_test%2F" \
         "destination%3Ahttp%3A%2F%2Fwww.prp_url.com"
      })
      controller.stub(:meta).and_return(meta_double)

      get :redirection, id: 1,
         pn: "test_product",
         ptu: "http%3A%2F%2Fprf.hn%2Fclick%2Fcamref%3A1234%2F" \
         "pubref%3Ahttp%3A%2F%2Ftest.host%2Fbondijunction%2Fproducts%2F1%3F" \
         "utm_campaign%3Dxyz%26utm_keyword%3Ddresses%26utm_medium%3Daffiliate%26" \
         "utm_source%3Dgoogleshopping%7C1.2.3.4%7Cexpression%7Cgoogleshopping" \
         "%7Caffiliate%7Cdresses%2Fadref%3Aspec_test%2F" \
         "destination%3Ahttp%3A%2F%2Fwww.prp_url.com",
         rcn: "product_rcn"
    end

  end
end
