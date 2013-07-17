require 'spec_helper'

describe EventsController do

  describe "GET #index" do
    before :each do
      CentreService.should_receive(:fetch).with('bondijunction').and_return double :response, body: {}
      EventService.should_receive(:fetch).with centre: 'bondijunction', rows: 50, published: true
    end
    it "populates an array of events" do
      get :index, centre_id: 'bondijunction'
    end
    it "renders the :index view" do
      get :index, centre_id: 'bondijunction'
      response.should render_template :index
    end
  end

  describe "GET #show" do
    before :each do
      CentreService.should_receive(:fetch).with('bondijunction').and_return double :response, body: {}
      EventService.should_receive(:fetch).with "1"
    end
    it "assigns the requested event to @event" do
      get :show, id: 1, centre_id: 'bondijunction'
    end
    it "renders the :show template" do
      get :show, id: 1, centre_id: 'bondijunction'
      response.should render_template :show
    end
  end

end
