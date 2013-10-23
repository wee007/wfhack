require 'spec_helper'

describe CentreHoursController do

  context "GET" do

    describe :show do

      it "renders trading_hours_index view" do
        CentreService.should_receive( :fetch ).with('chatswood').and_return double :response, body: {}
        CentreTradingHourService.should_receive( :fetch ).with('chatswood').and_return double :response, body: {}
        CentreTradingHourService.should_receive( :build )
        StoreService.should_receive( :fetch ).with({centre: 'chatswood', per_page: 'all', has_opening_hours: true}).and_return double :response, body: {}
        StoreService.should_receive( :build )

        get :show, centre_id: 'chatswood'
        response.should render_template :show
      end

    end

  end

end
