require 'spec_helper'

describe CentresController do

  let(:meta) { double(:meta) }

  describe :index do

    before do
      ProductService.should_receive(:fetch).with({ rows: 1 }).and_return double(:response, body: {})
      CentreService.should_receive(:fetch).with(:all, { country: 'au' }).and_return double(:response, body: {})
    end

    it "renders index view" do
      get :index
      response.should render_template :index
    end

    it "adds page title and description to meta" do
      meta.should_receive(:push).with({
        page_title: 'Westfield Australia | Shopping Centres in NSW, QLD, VIC, SA & WA',
        description: 'Find the best in retail, dining, leisure and entertainment at one of our centres across Australia, shop online or buy a gift card today'
      })
      controller.stub(:meta).and_return(meta)
      get :index
    end

  end

  describe :show do

    before do
      CentreService.should_receive(:fetch).with('centre').and_return double(:response, body: { name: 'Centre name', type: 'aspirational' })
      StreamService.should_receive(:fetch).with(centre: 'centre').and_return double(:response, body: {})
      CentreTradingHourService.should_receive(:fetch).with('centre', an_instance_of(Hash)).and_return double(:response, body: {})
    end

    it "renders show view" do
      get :show, id: 'centre'
      response.should render_template :show
    end

    describe "gon" do
      let(:gon) { double(:gon, meta: Meta.new) }

      context "when google content experiment param is not present" do
        it "assigns nil google_content_experiment variable" do
          controller.stub(:gon).and_return(gon)
          gon.should_receive(:push).with(google_content_experiment: nil, centre_id: nil)
          gon.should_receive(:push).with(centre_id: 'centre')
          get :show, id: 'centre'
        end
      end

      context "when google content experiment param is present" do
        it "assigns the param value to google_content_experiment variable" do
          controller.stub(:gon).and_return(gon)
          gon.should_receive(:push).with(google_content_experiment: '1', centre_id: nil)
          gon.should_receive(:push).with(centre_id: 'centre')
          get :show, id: 'centre', gce_var: 1
        end
      end
    end

    it "adds page title and description to meta" do
      meta.should_receive(:push).with({
        page_title: 'Centre name',
        description: 'Find your favourite store and the newest shops for fashion, beauty, lifestyle and fresh food only at Centre name'
      })
      controller.stub(:meta).and_return(meta)
      get :show, id: 'centre'
    end

  end

end