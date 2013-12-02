require 'spec_helper'

describe ProductsController do

  before :each do
    StoreService.stub(:fetch)
    CentreService.stub(:fetch).and_return double :centre_service_response, body: {}
    CentreService.stub(:group_by_state)
    ProductService.stub(:fetch).and_return double( :product_service_response,
      body: {
        details: [],
        retail_chain: {cam_ref: ""},
        categories: [{super_category: {code: ""}}],
        image_urls: []
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

    describe 'meta data for centre page' do

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

      context "when requesting for page title and meta description for a given super category" do
        it "includes the super category name in the page title and meta description, and adds to meta" do
          meta_double = double :meta
          meta_double.should_receive(:push).with({
            page_title: "Buy Products online at Westfield Bondi Junction",
            description: "Browse the latest Products online at Westfield Bondi Junction"
          })
          controller.stub(:meta).and_return(meta_double)
          get :index, centre_id: 'bondijunction', super_cat: 'products'
        end
      end

      context "when requesting for page title and meta description for a given category and super category" do
        it "includes the category name in the page title and meta description, and adds to meta" do
          meta_double = double :meta
          meta_double.should_receive(:push).with({
            page_title: "Buy Product 2 online at Westfield Bondi Junction",
            description: "Browse the latest Product 2 online at Westfield Bondi Junction"
          })
          controller.stub(:meta).and_return(meta_double)
          get :index, centre_id: 'bondijunction', category: 'product-2', super_cat: 'product-1'
        end
      end

      context "when requesting for page title and meta description for a given sub-category, category and super category" do
        it "includes the sub-category name in the page title and meta description, and add to meta" do
          meta_double = double :meta
          meta_double.should_receive(:push).with({
            page_title: "Buy Product 2 online at Westfield Bondi Junction",
            description: "Browse the latest Product 2 online at Westfield Bondi Junction"
          })
          controller.stub(:meta).and_return(meta_double)
          get :index, centre_id: 'bondijunction', sub_category: ['product-2'], category: 'product-1'
        end
      end

      context "when requesting for page title and meta description for given sub-categories, category and super category" do
        it "includes the sub-category names in the page title and meta description, and adds to meta" do
          meta_double = double :meta
          meta_double.should_receive(:push).with({
            page_title: "Buy Product 3 and Product 4 online at Westfield Bondi Junction",
            description: "Browse the latest Product 3 and Product 4 online at Westfield Bondi Junction"
          })
          controller.stub(:meta).and_return(meta_double)
          get :index, centre_id: 'bondijunction', sub_category: ['product-3','product-4'], category: 'product-2', super_cat: 'product-1'
        end
      end

      context "when requesting for page title and meta description for given a retailer" do
        it "includes the retailer name and description in the page title and meta description respectively, and adds to meta" do
          meta_double = double :meta
          meta_double.should_receive(:push).with({
            page_title: "Retailer at Westfield Bondi Junction",
            description: "Find the latest fashion, clothes, shoes, jewellery, accessories and much more at Westfield Bondi Junction"
          })
          controller.stub(:meta).and_return(meta_double)
          get :index, centre_id: 'bondijunction', retailer: ['retailer']
        end
      end

    end

    describe 'meta data for national page' do

      context "when requesting for page title and meta description" do
        it "adds the generic page title and meta description to meta" do
          meta_double = double :meta
          meta_double.should_receive(:push).with({
            page_title: "Shopping at Westfield",
            description: "Find the latest fashion, clothes, shoes, jewellery, accessories and much more at Westfield"
          })
          controller.stub(:meta).and_return(meta_double)
          get :index
        end
      end

      context "when requesting for page title and meta description for a given super category" do
        it "includes the super category name in the page title and meta description, and adds to meta" do
          meta_double = double :meta
          meta_double.should_receive(:push).with({
            page_title: "Buy Products online at Westfield",
            description: "Browse the latest Products online at Westfield"
          })
          controller.stub(:meta).and_return(meta_double)
          get :index, super_cat: 'products'
        end
      end

      context "when requesting for page title and meta description for a given category and super category" do
        it "includes the category name in the page title and meta description, and adds to meta" do
          meta_double = double :meta
          meta_double.should_receive(:push).with({
            page_title: "Buy Product 2 online at Westfield",
            description: "Browse the latest Product 2 online at Westfield"
          })
          controller.stub(:meta).and_return(meta_double)
          get :index, category: 'product-2', super_cat: 'product-1'
        end
      end

      context "when requesting for page title and meta description for a given sub-category, category and super category" do
        it "includes the sub-category name in the page title and meta description, and add to meta" do
          meta_double = double :meta
          meta_double.should_receive(:push).with({
            page_title: "Buy Product 2 online at Westfield",
            description: "Browse the latest Product 2 online at Westfield"
          })
          controller.stub(:meta).and_return(meta_double)
          get :index, sub_category: ['product-2'], category: 'product-1'
        end
      end

      context "when requesting for page title and meta description for given sub-categories, category and super category" do
        it "includes the sub-category names in the page title and meta description, and adds to meta" do
          meta_double = double :meta
          meta_double.should_receive(:push).with({
            page_title: "Buy Product 3 and Product 4 online at Westfield",
            description: "Browse the latest Product 3 and Product 4 online at Westfield"
          })
          controller.stub(:meta).and_return(meta_double)
          get :index, sub_category: ['product-3','product-4'], category: 'product-2', super_cat: 'product-1'
        end
      end

      context "when requesting for page title and meta description for given a retailer" do
        it "includes the retailer name and description in the page title and meta description respectively, and adds to meta" do
          meta_double = double :meta
          meta_double.should_receive(:push).with({
            page_title: "Retailer at Westfield",
            description: "Find the latest fashion, clothes, shoes, jewellery, accessories and much more at Westfield"
          })
          controller.stub(:meta).and_return(meta_double)
          get :index, retailer: ['retailer']
        end
      end

    end
  end

  describe "GET #show" do
    it "assigns the centre instance variable and redirection url" do
      get :show, id: 1, centre_id: 'bondijunction', retailer_code: 'retailer_code', product_name: 'product_name'
      response.should render_template :show
      assigns(:centre).should_not be_nil
      assigns(:product_redirection_url).should == centre_product_redirection_url
    end

    it "does not assign the centre instance variable and does assigns centre redirection url" do
      get :show, id: 1, retailer_code: 'retailer_code', product_name: 'product_name'
      response.should render_template :show
      assigns(:centre).should be_nil
      assigns(:product_redirection_url).should == product_redirection_url
    end
  end


  describe "GET #redirection" do
    context "when cam_ref is missing" do
      before :each do
        ProductService.stub(:fetch).and_return double( :response,
          body: {
            details: [],
            name: "test_product",
            retail_chain_name: "product_rcn",
            primary_retailer_product_url: "http://www.prp_url.com",
            retail_chain: {cam_ref: "", name: "product_rcn"},
            categories: [{super_category: {code: "spec_test"}}]
          }
        )
      end

      it "assigns proper data from url to meta" do
        @request.env['REMOTE_ADDR'] = '1.2.3.4'
        meta_double = double :meta
        meta_double.should_receive(:push).with({
          retail_chain_name: "product_rcn",
          page_title: "product_rcn - test_product",
          product_tracking_url: "http://www.prp_url.com"
        })
        controller.stub(:meta).and_return(meta_double)

        get :redirection, id: 1
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

      it "assigns proper data from url to meta" do
        @request.env['REMOTE_ADDR'] = '1.2.3.4'
        meta_double = double :meta
        meta_double.should_receive(:push).with({
          retail_chain_name: "product_rcn",
          page_title: "product_rcn - test_product",
          product_tracking_url: "http://prf.hn/click/camref:1234/" \
            "pubref:http://test.host/products/1%7C1.2.3.4%7C%7C%7C%7C/" \
            "adref:spec_test/destination:http://www.prp_url.com"
        })
        controller.stub(:meta).and_return(meta_double)

        get :redirection, id: 1,
          utm_keyword: "dresses", utm_medium: "affiliate", utm_source: "googleshopping"
        # In integration, js in browser will fill in utm data in between %7C above
      end
    end

  end
end
