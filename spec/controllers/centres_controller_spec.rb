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

    describe :show do

      it "renders show view" do
        CentreService.should_receive( :fetch ).with('1').and_return mock :response, body: {}
        StreamService.should_receive( :fetch ).with('1').and_return mock :response, body: {}
        get :show, id: 1
        response.should render_template :show
      end

    end

    describe :trading_hours_index do

      it "renders trading_hours_index view" do
        CentreService.should_receive( :fetch ).with('chatswood').and_return mock :response, body: {}
        get :trading_hours_index, centre_id: 'chatswood'
        response.should render_template 'trading_hours/index'
      end

    end

  end

end
