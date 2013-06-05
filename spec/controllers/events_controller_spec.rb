require 'spec_helper'

describe EventsController do

  describe "GET #index" do
    it "populates an array of events" do
      CentreService.should_receive(:fetch).with 'bondijunction'
      EventService.should_receive(:fetch).with centre: 'bondijunction', rows: 50
      get :index, centre_id: 'bondijunction'
    end
    it "renders the :index view" do
      get :index, centre_id: 'bondijunction'
      response.should render_template :index
    end
  end

  describe "GET #show" do
    it "assigns the requested event to @event" do
      CentreService.should_receive(:fetch).with 'bondijunction'
      EventService.should_receive(:fetch).with "1"
      get :show, id: 1, centre_id: 'bondijunction'
    end
    it "renders the :show template" do
      get :show, id: 1, centre_id: 'bondijunction'
      response.should render_template :show
    end
  end

end