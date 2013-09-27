require 'spec_helper'

describe EventsController do

  before :each do
    CentreService.stub(:fetch).and_return double :response, body: {short_name: "Centre name"}
    EventService.stub(:fetch).with centre: 'bondijunction', rows: 50, published: true
    EventService.stub(:fetch).with('1').and_return double :response, body: {name: "Event name", "_links" => {image: {href: 'image_link'}}}
  end

  describe "GET #index" do
    before :each do
      get :index, centre_id: 'bondijunction'
    end

    it "renders the :index view" do
      response.should render_template :index
    end

    it "adds title to meta" do
      meta_double = double :meta
      meta_double.should_receive(:push).with title: "Centre name events"
      controller.stub(:meta).and_return(meta_double)
      get :index, centre_id: 'bondijunction'
    end

  end

  describe "GET #show" do

    before :each do
      get :show, id: 1, centre_id: 'bondijunction'
    end

    it "renders the :show template" do
      response.should render_template :show
    end

    it "adds event meta to meta" do
      EventService.stub(:build).and_return(double :event, meta: 'event meta')
      meta_double = double :meta
      meta_double.should_receive(:push).with 'event meta'
      controller.stub(:meta).and_return(meta_double)
      get :show, id: 1, centre_id: 'bondijunction'
    end
  end

end