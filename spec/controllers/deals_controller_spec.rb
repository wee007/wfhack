require 'spec_helper'

#TODO: replace all these doubles with VCR

describe DealsController do

  describe "GET #index" do
    before :each do
      CentreService.stub(:fetch).with('bondijunction').and_return double :response, body: {name: 'Centre name'}
      DealService.stub(:fetch).with(centre: 'bondijunction', rows: 50).and_return("DEAL JSON")
      DealService.stub(:build).with("DEAL JSON").and_return(['Deal', 'Deal1'])
      get :index, centre_id: 'bondijunction'
    end
    it "populates an array of deals" do
      expect(assigns(@deals)['deals']).to eql(['Deal', 'Deal1'])
    end
    it "renders the :index view" do
      response.should render_template :index
    end
    it "populates page_title" do
      expect(assigns(:page_title)).to eql "Centre name deals"
    end
  end

  describe "GET #show" do
    before :each do
      CentreService.stub(:fetch).with('bondijunction').and_return double :response, body: {}
      DealService.stub(:fetch).with("1").and_return("DEAL JSON")
      stub_deal_store = double(:deal_store, :id => 12).as_null_object
      StoreService.stub(:fetch).with(12).and_return("STORE JSON")
      @stub_store = double(:store).as_null_object
      StoreService.stub(:build).with("STORE JSON").and_return(@stub_store)
      @stub_deal = double(:deal, title: 'Deal title', :deal_stores => stub_deal_store).as_null_object
      DealService.stub(:build).with("DEAL JSON").and_return(@stub_deal)
      @gon = double :gon
      @gon.stub(:push)
      DealsController.any_instance.stub(:gon).and_return(@gon)
      get :show, id: 1, centre_id: 'bondijunction'
    end
    it "assigns the requested deal" do
      expect(assigns(@deal)['deal']).to eql(@stub_deal)
    end
    it "assigns the requested store" do
      expect(assigns(@store)['store']).to eql(@stub_store)
    end
    it "renders the :show template" do
      get :show, id: 1, centre_id: 'bondijunction'
      response.should render_template :show
    end
    it "adds centre and store to gon" do
      @gon.should_receive(:push).with(centre: {}, stores: [@stub_store])
      get :show, id: 1, centre_id: 'bondijunction'
    end
    it "populates page_title" do
      expect(assigns(:page_title)).to eql "Deal title"
    end
  end

end
