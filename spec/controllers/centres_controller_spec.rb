require 'spec_helper'

describe CentresController do

  context "GET" do

    describe :index do

      it "renders index view" do
        CentreService.should_receive( :find ).with(:all, { country: 'au' }).and_return []
        get :index
        response.should render_template :index
      end

    end

    describe :product_stream do
      it "renders show view" do
        CentreService.should_receive( :fetch ).with('1').and_return double :response, body: {}
        StreamService.should_receive( :fetch ).with(centre: '1', stream: 'product').and_return double :response, body: {}
        get :product_stream, id: 1
        response.should render_template :show
      end
    end

    describe :show do

      it "renders show view" do
        CentreService.should_receive( :fetch ).with('1').and_return double :response, body: {}
        StreamService.should_receive( :fetch ).with(centre: '1').and_return double :response, body: {}
        get :show, id: 1
        response.should render_template :show
      end

    end

  end

end
