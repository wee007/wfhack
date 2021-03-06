require 'spec_helper'

describe ProductsController do

  before :each do
    StoreService.stub(:fetch)
    CentreService.stub(:fetch).and_return double :centre_service_response, body: {}
    CentreService.stub(:group_by_state)
    CentreTradingHour.stub(:fetch)
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

  describe :index_centre do
    let(:search_object) do
      Hashie::Mash.new(
        count: 50,
        rows: 50,
        products: [],
        applied_filters: {},
        seo: Hashie::Mash.new(
          page_title: '',
          description: ''
        )
      )
    end

    before do
      CentreService.stub( :fetch ).and_return \
        double( :response,
          body: {
            state: 'NSW',
            name: 'Westfield Bondi Junction'
          },
          products: [],
          applied_filters: {}
        )
    end

    context "when centre is present" do
      it "assigns the centre instance variable" do
        ProductService.stub( :build ).and_return( search_object )
        get :index_centre, centre_id: 'bondijunction'
        response.should render_template :index
        assigns(:centre).should_not be_nil
      end
    end

    describe "gon" do
      let(:gon) { double(:gon, meta: Meta.new) }
      let(:products_params) {
        {
          display_options: nil,
          facets: nil,
          applied_filters: Hashie::Mash.new(),
          count: 0
        }
      }

      before(:each) { ProductService.stub(:build).and_return(search_object) }

      context "when google content experiment param is not present" do
        it "assigns nil google_content_experiment variable" do
          controller.stub(:gon).and_return(gon)
          gon.should_receive(:push).with(:google_content_experiment=>nil, :centre_id=>"bondijunction")
          gon.should_receive(:push).with(products: products_params)
          get :index_centre, centre_id: 'bondijunction'
        end
      end

      context "when google content experiment param is present" do
        it "assigns the param value to google_content_experiment variable" do
          controller.stub(:gon).and_return(gon)
          gon.should_receive(:push).with(:google_content_experiment=>"1", :centre_id=>"bondijunction")
          gon.should_receive(:push).with(products: products_params)
          get :index_centre, centre_id: 'bondijunction', gce_var: 1
        end
      end
    end

    describe 'meta data for centre page' do
      context "when requesting for page title and meta description" do
        let( :search_object ) do
          Hashie::Mash.new(
            count: 50,
            rows: 50,
            products: [],
            applied_filters: {},
            seo: Hashie::Mash.new(
              page_title: 'Shopping',
              description: 'Find the latest fashion, clothes, shoes, jewellery, accessories and much more'
            )
          )
        end

        it "adds page title and meta description to meta" do
          ProductService.stub( :build ).and_return( search_object )
          meta_double = double :meta
          meta_double.should_receive(:push).with({
            page_title: "Shopping at Westfield Bondi Junction",
            description: "Find the latest fashion, clothes, shoes, jewellery, accessories and much more at Westfield Bondi Junction"
          })
          controller.stub(:meta).and_return(meta_double)
          get :index_centre, centre_id: 'bondijunction'
        end
      end

    end

    describe :params do
      let( :search_object ) do
        Hashie::Mash.new(
          count: 50,
          rows: 50,
          products: [],
          applied_filters: {},
          seo: Hashie::Mash.new(
            page_title: '',
            description: ''
          )
        )
      end

      context "when gclid param is present" do
        it "remove gclid param" do
          ProductService.stub( :build ).and_return( search_object )
          controller.stub(:params).and_return({ centre_id: 'bondijunction' })
          get :index_centre, centre_id: 'bondijunction', gclid: 'CN3h6JTO4LsCFfFV4god9gMAkQ'
        end
      end
    end
  end

  describe :index_national do
    before do
      CentreService.stub( :fetch ).and_return \
        double( :response,
          body: [
            {
              state: 'NSW',
              name: 'Westfield Bondi Junction'
            }
          ]
        )
    end

    context "when centre is not present" do
      let( :search_object ) do
        Hashie::Mash.new(
          count: 50,
          rows: 50,
          seo: Hashie::Mash.new(
            page_title: '',
            description: ''
          )
        )
      end

      it "does not assign the centre instance variable" do
        ProductService.stub( :build ).and_return( search_object )
        get :index_national
        response.should render_template :index
        assigns(:centre).should be_nil
      end
    end

    describe 'meta data for national page' do
      context "when requesting for page title and meta description" do
        let( :search_object ) do
          Hashie::Mash.new(
            count: 50,
            rows: 50,
            seo: Hashie::Mash.new(
              page_title: 'Shopping',
              description: 'Find the latest fashion, clothes, shoes, jewellery, accessories and much more'
            )
          )
        end

        it "adds the generic page title and meta description to meta" do
          ProductService.stub( :build ).and_return( search_object )
          meta_double = double :meta
          meta_double.should_receive(:push).with({
            page_title: "Shopping at Westfield",
            description: "Find the latest fashion, clothes, shoes, jewellery, accessories and much more at Westfield"
          })
          controller.stub(:meta).and_return(meta_double)
          get :index_national
        end
      end

    end

    describe :params do
      let( :search_object ) do
        Hashie::Mash.new(
          count: 50,
          rows: 50,
          seo: Hashie::Mash.new(
            page_title: '',
            description: ''
          )
        )
      end

      context "when gclid param is present" do
        it "remove gclid param" do
          ProductService.stub( :build ).and_return( search_object )
          controller.stub(:params).and_return({})
          get :index_national, gclid: 'CN3h6JTO4LsCFfFV4god9gMAkQ'
        end
      end
    end
  end

  describe :show_centre do
    describe :store do
      context "when store is NOT present" do
        it "returns nil indicating no store found" do
          get :show_centre, id: 1, centre_id: 'bondijunction', retailer_code: 'retailer_code', product_name: 'product_name'
          expect(controller.send(:store)).to eq(nil)
        end
      end

      context "when store is present" do
        let(:stores) { [Hashie::Mash.new(name: 'Store Name', retailer_code: 'retailer_code')] }

        it "returns the appropriate text with the store name" do
          StoreService.stub(:build).and_return(stores)
          get :show_centre, id: 1, centre_id: 'bondijunction', retailer_code: 'retailer_code', product_name: 'product_name'
          expect(controller.send(:store)).to eq(" from Store Name")
        end
      end
    end

    describe "gon" do
      let(:gon) { double(:gon, meta: Meta.new) }

      context "when google content experiment param is not present" do
        it "assigns nil google_content_experiment variable" do
          controller.stub(:gon).and_return(gon)
          gon.should_receive(:push).with(google_content_experiment: nil, centre_id: "bondijunction")
          gon.should_receive(:push).with(centre: Hashie::Mash.new, stores: {})
          get :show_centre, id: 1, centre_id: 'bondijunction', retailer_code: 'retailer_code', product_name: 'product_name'
        end
      end

      context "when google content experiment param is present" do
        it "assigns the param value to google_content_experiment variable" do
          controller.stub(:gon).and_return(gon)
          gon.should_receive(:push).with(centre: Hashie::Mash.new, stores: {})
          gon.should_receive(:push).with(google_content_experiment: "1", centre_id: "bondijunction")
          get :show_centre, id: 1, centre_id: 'bondijunction', retailer_code: 'retailer_code', product_name: 'product_name', gce_var: 1
        end
      end
    end

    it "assigns the centre instance variable and redirection url" do
      get :show_centre, id: 1, centre_id: 'bondijunction', retailer_code: 'retailer_code', product_name: 'product_name'
      response.should render_template :show
      assigns(:centre).should_not be_nil
      assigns(:product_redirection_url).should == centre_product_redirection_url
    end

    describe :params do
      it "remove gclid param" do
        controller.stub(:params).and_return({ id: 1, centre_id: 'bondijunction', retailer_code: 'retailer_code', product_name: 'product_name' })
        get :show_centre, id: 1, centre_id: 'bondijunction', retailer_code: 'retailer_code', product_name: 'product_name', gclid: 'CN3h6JTO4LsCFfFV4god9gMAkQ'
      end
    end

  end

  describe :show_national do
    let(:centres) do
      [
        Hashie::Mash.new(
          code: 'bondijunction',
          state: 'NSW'
        ),
        Hashie::Mash.new(
          code: 'sydney',
          state: 'NSW'
        ),
        Hashie::Mash.new(
          code: 'carindale',
          state: 'QLD'
        )
      ]
    end
    let(:stores) do
      [
        Hashie::Mash.new(
          retailer_code: 'retailer_code',
          centre_id: 'sydney'
        ),
        Hashie::Mash.new(
          retailer_code: 'retailer_code',
          centre_id: 'carindale'
        )
      ]
    end

    it "does not assign the centre instance variable and does assigns centre redirection url" do
      CentreService.stub(:build).and_return(centres)
      StoreService.stub(:build).and_return(stores)

      get :show_national, id: 1, retailer_code: 'retailer_code', product_name: 'product_name'

      expect(response).to render_template(:show)

      expect(assigns(:centre)).to be_nil
      expect(assigns(:centres_by_store)).to eql(
        {
          'NSW' => [
            {
              'code' => 'sydney',
              'state' => 'NSW'
            }
          ],
          'QLD' => [
            {
              'code' => 'carindale',
              'state' => 'QLD'
            }
          ]
        }
      )
      expect(assigns(:product_redirection_url)).to  eq(product_redirection_url)
    end

    describe :params do
      it "remove gclid param" do
        controller.stub(:params).and_return({ id: 1, retailer_code: 'retailer_code', product_name: 'product_name' })
        get :show_national, id: 1, retailer_code: 'retailer_code', product_name: 'product_name', gclid: 'CN3h6JTO4LsCFfFV4god9gMAkQ'
      end
    end
  end


  describe :redirection do
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