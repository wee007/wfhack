require 'spec_helper'

describe CentreHoursController do

  let(:store_hours) {
    [
      {
        store_id: 1,
        day_of_week: 0,
        opening_time: '09:00',
        closing_time: '17:00',
        closed: false
      },
      {
        store_id: 1,
        day_of_week: 1,
        opening_time: '09:00',
        closing_time: '17:00',
        closed: false
      },
      {
        store_id: 1,
        day_of_week: 2,
        opening_time: '09:00',
        closing_time: '17:00',
        closed: false
      },
      {
        store_id: 1,
        day_of_week: 3,
        opening_time: '09:00',
        closing_time: '17:00',
        closed: false
      },
      {
        store_id: 1,
        day_of_week: 4,
        opening_time: '09:00',
        closing_time: '17:00',
        closed: false
      },
      {
        store_id: 1,
        day_of_week: 5,
        opening_time: '09:00',
        closing_time: '17:00',
        closed: false
      },
      {
        store_id: 1,
        day_of_week: 6,
        opening_time: '09:00',
        closing_time: '17:00',
        closed: false
      },
      {
        store_id: 1,
        day_of_week: 0,
        opening_time: '09:00',
        closing_time: '17:00',
        closed: false
      },
      {
        store_id: 1,
        day_of_week: 1,
        opening_time: '09:00',
        closing_time: '17:00',
        closed: false
      },
      {
        store_id: 1,
        day_of_week: 2,
        opening_time: '09:00',
        closing_time: '17:00',
        closed: false
      },
      {
        store_id: 1,
        day_of_week: 3,
        opening_time: '09:00',
        closing_time: '17:00',
        closed: false
      },
      {
        store_id: 1,
        day_of_week: 4,
        opening_time: '09:00',
        closing_time: '17:00',
        closed: false
      },
      {
        store_id: 1,
        day_of_week: 5,
        opening_time: '09:00',
        closing_time: '17:00',
        closed: false
      },
      {
        store_id: 1,
        day_of_week: 6,
        opening_time: '09:00',
        closing_time: '17:00',
        closed: false
      }
    ]
  }

  context "GET" do

    describe :show do

      it "renders trading_hours_index view" do
        CentreService.should_receive( :fetch ).with('chatswood').and_return double :response, body: {}
        CentreTradingHourService.should_receive( :fetch ).with('chatswood').and_return double :response, body: {}
        CentreTradingHourService.should_receive( :build ).and_return([])
        StoreService.should_receive( :fetch ).with({centre: 'chatswood', per_page: 'all', has_opening_hours: true}).and_return double :response, body: store_hours
        StoreService.should_receive( :build )

        get :show, centre_id: 'chatswood'
        response.should render_template :show
      end

    end

  end

end
