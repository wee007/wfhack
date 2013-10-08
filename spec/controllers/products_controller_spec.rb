require 'spec_helper'

describe ProductsController do

  before :each do
    StoreService.stub(:fetch)
    CentreService.stub(:fetch).and_return double :response, body: {}
    CentreService.stub(:group_by_state)
    ProductService.stub(:fetch).and_return double :response, body: {details: []}
  end

  describe "GET #index" do
    before :each do
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
  end

  describe "GET #show" do
    it "does not assign the centre instance variable" do
      get :show, retailer_code: 'colette-accessories', centre_id: 'bondijunction', sku: 1
      response.should render_template :show
      assigns(:centre).should_not be_nil
    end

    it "assigns the centre instance variable" do
      get :show, retailer_code: 'colette-accessories', sku: 1
      response.should render_template :show
      assigns(:centre).should be_nil
    end
  end

end
