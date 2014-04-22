require 'spec_helper'

#TODO: replace all these doubles with VCR

describe DealsController do

  describe "GET #index" do
    let(:meta) { double :meta }

    before :each do
      CentreService.stub(:fetch).with('bondijunction').and_return double :response, body: {name: 'Centre name'}
      DealService.stub(:fetch).with(centre: 'bondijunction', campaign_code: 'halloween', state: "published", rows: 50).and_return("DEAL JSON")
      DealService.stub(:build).with("DEAL JSON").and_return(['Deal', 'Deal1'])
      CampaignService.stub(:fetch).with(centre: 'bondijunction').and_return("CAMPAIGN JSON")
      CampaignService.stub(:build).with("CAMPAIGN JSON").and_return(['Campaign', 'Campaign'])
      controller.stub(:eager_load_stores)
      get :index, centre_id: 'bondijunction', campaign_code: 'halloween'
    end

    it "populates an array of deals" do
      expect(assigns(@deals)['deals']).to eql(['Deal', 'Deal1'])
    end

    it "renders the :index view" do
      response.should render_template :index
    end

    describe "gon" do
      let(:gon) { double(:gon, meta: Meta.new) }

      context "when google content experiment param is not present" do
        it "assigns nil google_content_experiment variable" do
          controller.stub(:gon).and_return(gon)
          gon.should_receive(:push).with(google_content_experiment: nil)
          get :index, centre_id: 'bondijunction', campaign_code: 'halloween'
        end
      end

      context "when google content experiment param is present" do
        it "assigns the param value to google_content_experiment variable" do
          controller.stub(:gon).and_return(gon)
          gon.should_receive(:push).with(google_content_experiment: '1')
          get :index, centre_id: 'bondijunction', campaign_code: 'halloween', gce_var: 1
        end
      end
    end

    it "adds title to meta" do
      meta.should_receive(:push).with({
        page_title: "Deals, Sales & Special Offers available at Centre name",
        description: "Find the best deals, sales and great offers on a variety of products and brands at Centre name"
      })
      controller.stub(:meta).and_return(meta)
      get :index, centre_id: 'bondijunction', campaign_code: 'halloween'
    end
  end

  describe "GET #show" do
    let(:centre_id) { 'bondijunction' }
    let(:store_service_id) { 12 }
    let(:deal_store) { double(:deal_store, store_service_id: store_service_id, centre_id: centre_id) }
    let(:store) { double(:store).as_null_object }

    let(:deal_1) {
      # FIXME: Drinking too much Koolaid with all these mocks. Minimally,
      # removed 'as_null_object' calls since it can mask malformed models.
      double(:deal,
        title: 'Deal title',
        description: 'Some description',
        available_to: DateTime.new( Time.now.year+1, 01, 01 ),
        deal_stores: [ deal_store ],
        published?: true,
        meta: {}
      )
    }

    let(:deal_2) {
      double(:deal,
        meta: 'deal meta',
        title: 'Deal title',
        description: 'Some description',
        available_to: DateTime.new( Time.now.year+1, 01, 01 ),
        deal_stores: [ deal_store ],
        published?: true,
        meta: {}
      )
    }

    let(:meta) { double :meta }

    before :each do
      CentreService.stub(:fetch).with(centre_id).and_return double :response, body: {}
      DealService.stub(:fetch).with("1").and_return("DEAL JSON")
      StoreService.stub(:fetch).with(store_service_id).and_return("STORE JSON")
      StoreService.stub(:build).with("STORE JSON").and_return(store)
      DealService.stub(:build).with("DEAL JSON").and_return(deal_1)
      get :show, id: 1, centre_id: 'bondijunction', retailer_code: 'for-tracking'
    end

    it "assigns the requested deal" do
      expect(assigns(@deal)['deal']).to eql(deal_1)
    end

    it "assigns the requested store" do
      expect(assigns(@store)['store']).to eql(store)
    end

    it "renders the :show template" do
      expect(response).to render_template :show
    end

    describe "gon" do
      let(:gon) { double(:gon, meta: Meta.new) }

      context "when google content experiment param is not present" do
        it "assigns nil google_content_experiment variable" do
          controller.stub(:gon).and_return(gon)
          gon.should_receive(:push).with(centre: {}, stores: [store], google_content_experiment: nil)
          get :show, id: 1, centre_id: 'bondijunction', retailer_code: 'for-tracking'
        end
      end

      context "when google content experiment param is present" do
        it "assigns the param value to google_content_experiment variable" do
          controller.stub(:gon).and_return(gon)
          gon.should_receive(:push).with(centre: {}, stores: [store], google_content_experiment: '1')
          get :show, id: 1, centre_id: 'bondijunction', retailer_code: 'for-tracking', gce_var: 1
        end
      end
    end

    it "adds title to meta" do
      DealService.stub(:build).with("DEAL JSON").and_return(deal_2)
      meta.should_receive(:push).with(deal_2.meta)
      meta.should_receive(:push).with({
        title: "#{deal_2.title} from #{store.name}",
        page_title: "#{deal_2.title} from #{store.name} at ",
        description: "At , find #{ deal_2.title } - ends #{ deal_2.available_to.strftime("%Y-%m-%d") }"
      })
      controller.stub(:meta).and_return(meta)
      get :show, id: 1, centre_id: 'bondijunction', retailer_code: 'for-tracking'
    end

    context "when a deal expired" do

      let( :expired_deal ) do
        Hashie::Mash.new(
          state: 'expired',
          deal_stores: [ deal_store ]
        )
      end

      before( :each ) do
        DealService.stub( :build ).and_return( expired_deal )
        get :show, id: 1, centre_id: 'bondijunction', retailer_code: 'for-tracking'
      end

      it "returns four uh-oh! four" do
        expect( response.response_code ).to eq( 404 )
      end

    end

  end

end
