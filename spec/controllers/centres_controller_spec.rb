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
    end

    it "renders show view" do
      get :show, id: 'centre'
      response.should render_template :show
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