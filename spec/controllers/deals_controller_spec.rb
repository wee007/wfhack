require 'spec_helper'

#TODO: replace all these doubles with VCR

describe DealsController do

  describe "GET #index" do
    let(:meta) { double :meta }

    before :each do
      CentreService.stub(:fetch).with('bondijunction').and_return double :response, body: {name: 'Centre name'}
      DealService.stub(:fetch).with(centre: 'bondijunction', state: "published", rows: 50).and_return("DEAL JSON")
      DealService.stub(:build).with("DEAL JSON").and_return(['Deal', 'Deal1'])
      get :index, centre_id: 'bondijunction'
    end

    it "populates an array of deals" do
      expect(assigns(@deals)['deals']).to eql(['Deal', 'Deal1'])
    end

    it "renders the :index view" do
      response.should render_template :index
    end

    it "adds title to meta" do
      meta.should_receive(:push).with({
        page_title: "Deals, Sales & Special Offers available at Centre name",
        description: "Find the best deals, sales and great offers on a variety of products and brands at Centre name"
      })
      controller.stub(:meta).and_return(meta)
      get :index, centre_id: 'bondijunction'
    end
  end

  describe "GET #show" do
    let(:deal_store) { double(:deal_store, :store_service_id => 12).as_null_object }
    let(:store) { double(:store).as_null_object }
    let(:deal_1) {
      double(:deal,
        title: 'Deal title',
        description: 'Some description',
        available_to: DateTime.new(2013,01,01),
        :deal_stores => deal_store
      ).as_null_object
    }
    let(:deal_2) {
      double(:deal,
        meta: 'deal meta',
        title: 'Deal title',
        description: 'Some description',
        available_to: DateTime.new(2013,01,01),
        :deal_stores => deal_store
      ).as_null_object
    }
    let(:meta) { double :meta }

    before :each do
      CentreService.stub(:fetch).with('bondijunction').and_return double :response, body: {}
      DealService.stub(:fetch).with("1").and_return("DEAL JSON")
      StoreService.stub(:fetch).with(12).and_return("STORE JSON")
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
      response.should render_template :show
    end

    it "adds centre to gon" do
      gon = double :gon, meta: Meta.new
      controller.stub(:gon).and_return(gon)
      gon.should_receive(:push).with(centre: {})
      get :show, id: 1, centre_id: 'bondijunction', retailer_code: 'for-tracking'
    end

    it "adds title to meta" do
      DealService.stub(:build).with("DEAL JSON").and_return(deal_2)
      meta.should_receive(:push).with 'deal meta'
      meta.should_receive(:push).with({
        title: "#{deal_2.title} from #{store.name}",
        page_title: "#{deal_2.title} from #{store.name} at ",
        description: "At , find #{ deal_2.title } - ends #{ deal_2.available_to.strftime("%Y-%m-%d") }"
      })
      controller.stub(:meta).and_return(meta)
      get :show, id: 1, centre_id: 'bondijunction', retailer_code: 'for-tracking'
    end
  end

end
