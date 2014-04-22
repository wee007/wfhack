require 'spec_helper'

describe EventsController do

  let(:event) do
    Event.new name: "Event name", description: "Some description", "_links" => {image: {href: 'image_link'}}
  end

  let(:centre) do
    Centre.new name: "Centre name", timezone: "Australia/Sydney"
  end

  describe "GET #index" do
    before :each do
      controller.stub(:service_map).and_return [{}, centre]
      get :index, centre_id: 'bondijunction'
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
          get :index, centre_id: 'bondijunction'
        end
      end

      context "when google content experiment param is present" do
        it "assigns the param value to google_content_experiment variable" do
          controller.stub(:gon).and_return(gon)
          gon.should_receive(:push).with(google_content_experiment: '1')
          get :index, centre_id: 'bondijunction', gce_var: 1
        end
      end
    end

    it "adds title to meta" do
      meta_double = double :meta
      meta_double.should_receive(:push).with({
        page_title: "Events and Activities at Centre name",
        description: "Find the latest events and activities for children and adults taking place at Centre name"
      })
      controller.stub(:meta).and_return(meta_double)
      get :index, centre_id: 'bondijunction'
    end

  end

  describe "GET #show" do

    before :each do
      controller.stub(:service_map).and_return [event, centre]
    end

    it "renders the :show template" do
      get :show, id: 1, centre_id: 'bondijunction'
      response.should render_template :show
    end

    describe "gon" do
      let(:gon) { double(:gon, meta: Meta.new) }

      context "when google content experiment param is not present" do
        it "assigns nil google_content_experiment variable" do
          controller.stub(:gon).and_return(gon)
          gon.should_receive(:push).with(google_content_experiment: nil)
          get :show, id: 1, centre_id: 'bondijunction'
        end
      end

      context "when google content experiment param is present" do
        it "assigns the param value to google_content_experiment variable" do
          controller.stub(:gon).and_return(gon)
          gon.should_receive(:push).with(google_content_experiment: '1')
          get :show, id: 1, centre_id: 'bondijunction', gce_var: 1
        end
      end
    end

    it "adds event meta to meta" do
      meta_double = double :meta
      meta_double.should_receive(:push).with event.meta
      meta_double.should_receive(:push).with({
        twitter_title: "Check out this Event name at Centre name",
        page_title: "Event name at Centre name",
        description: "At Centre name, Some description"
      })
      controller.stub(:meta).and_return(meta_double)
      get :show, id: 1, centre_id: 'bondijunction'
    end
  end

end
