require 'spec_helper'

#TODO: replace all these doubles with VCR

describe DealsController do

  describe "GET #index" do
    before :each do
      CentreService.stub(:fetch).with('bondijunction').and_return double :response, body: {short_name: 'Centre name'}
      DealService.stub(:fetch).with(centre: 'bondijunction', state: "live", rows: 50).and_return("DEAL JSON")
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
      meta_double = double :meta
      meta_double.should_receive(:push).with title: "Centre name deals"
      controller.stub(:meta).and_return(meta_double)
      get :index, centre_id: 'bondijunction'
    end
  end

  describe "GET #show" do
    before :each do
      CentreService.stub(:fetch).with('bondijunction').and_return double :response, body: {}
      DealService.stub(:fetch).with("1").and_return("DEAL JSON")
      stub_deal_store = double(:deal_store, :store_service_id => 12).as_null_object
      StoreService.stub(:fetch).with(12).and_return("STORE JSON")
      @stub_store = double(:store).as_null_object
      StoreService.stub(:build).with("STORE JSON").and_return(@stub_store)
      @stub_deal = double(:deal, title: 'Deal title', :deal_stores => stub_deal_store).as_null_object
      DealService.stub(:build).with("DEAL JSON").and_return(@stub_deal)
      get :show, id: 1, centre_id: 'bondijunction'
    end
    it "assigns the requested deal" do
      expect(assigns(@deal)['deal']).to eql(@stub_deal)
    end
    it "assigns the requested store" do
      expect(assigns(@store)['store']).to eql(@stub_store)
    end
    it "renders the :show template" do
      response.should render_template :show
    end
    it "adds centre and store to gon" do
      gon = double :gon, meta: Meta.new
      controller.stub(:gon).and_return(gon)
      gon.should_receive(:push).with(centre: {}, stores: [@stub_store])
      get :show, id: 1, centre_id: 'bondijunction'
    end
    it "adds title to meta" do
      meta_double = double :meta
      meta_double.should_receive(:push).with title: @stub_deal.title
      controller.stub(:meta).and_return(meta_double)
      get :show, id: 1, centre_id: 'bondijunction'
    end
  end

end
