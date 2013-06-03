require 'spec_helper'

describe EventsController do

  subject { Service::API }

  describe "GET #index" do
    it "populates an array of events" do
      subject.should_receive(:get).with "http://customer-console.dev/api/event/master/events", rows: 50, centre: 'bondijunction'
      get :index, centre_id: 'bondijunction'
    end
    it "renders the :index view" do
      subject.stub(:get)
      get :index, centre_id: 'bondijunction'
      response.should render_template :index
    end
  end

  describe "GET #show" do
    it "assigns the requested event to @event" do
      subject.should_receive(:get).with "http://customer-console.dev/api/event/master/events/1"
      get :show, id: 1, centre_id: 'bondijunction'
    end
    it "renders the :show template" do
      subject.stub(:get)
      get :show, id: 1, centre_id: 'bondijunction'
      response.should render_template :show
    end
  end

end