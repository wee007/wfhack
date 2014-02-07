require 'spec_helper'

describe CentreInfoController do

  context "GET" do
    before(:each) do
      ParkingService.stub(:fetch)
    end
    describe :show do

      it "renders show view" do
        CentreService.should_receive(:fetch).with('chatswood').and_return double :response, body: {}
        CentreServiceNoticeService.should_receive(:fetch).with(:centre => 'chatswood', :active => true)
        CentreTradingHourService.should_receive(:fetch).with('chatswood')
        CentreTradingHourService.should_receive(:build).and_return([double({
                                                                            id: 540,
                                                                            centre_id: "caseycentral",
                                                                            store_id: nil,
                                                                            hour_type: "standard",
                                                                            description: nil,
                                                                            day_of_week: 0,
                                                                            date: Time.now.strftime("%Y-%m-%d"),
                                                                            opening_time: "09:00",
                                                                            closing_time: "17:00",
                                                                            closed: false
                                                                          })])
        get :show, centre_id: 'chatswood'
        response.should render_template :show
      end

    end
  end
end
