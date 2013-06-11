require 'spec_helper'

describe TradingHoursController do

  context "GET" do

    describe :index do

      it "renders trading_hours_index view" do
        CentreService.should_receive( :fetch ).with('chatswood').and_return mock :response, body: {}
        get :index, centre_id: 'chatswood'
        response.should render_template :index
      end

    end

  end

end
