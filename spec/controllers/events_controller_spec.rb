require 'spec_helper'

describe EventsController do

  before :each do
    CentreService.stub(:fetch).and_return double :response, body: {name: "Centre name"}
    EventService.stub(:fetch).with centre: 'bondijunction', rows: 50, published: true
    EventService.stub(:fetch).with('1').and_return double :response, body: {name: "Event name", image_ref: "Image_ref"}
  end

  describe "GET #index" do
    before :each do
      get :index, centre_id: 'bondijunction'
    end

    it "renders the :index view" do
      response.should render_template :index
    end

    it "populates page_title" do
      expect(assigns(:page_title)).to eql "Centre name events"
    end
  end

  describe "GET #show" do

    before :each do
      get :show, id: 1, centre_id: 'bondijunction'
    end

    it "renders the :show template" do
      response.should render_template :show
    end

    it "populates page_title" do
      expect(assigns(:page_title)).to eql "Event name"
    end

    it "populates page_image" do
      expect(assigns(:page_image)).to include "Image_ref"
    end
  end

end