require 'spec_helper'

describe CentreInfoController do

  context "GET" do
    before(:each) do
      ParkingService.stub(:fetch)
    end
    describe :show do

      it "renders show view" do
        CentreService.should_receive( :fetch ).with('chatswood').and_return double :response, body: {}
        CentreServiceNoticesService.should_receive( :fetch ).with(:centre => 'chatswood', :active => true)
        get :show, centre_id: 'chatswood'
        response.should render_template :show
      end

    end
  end
end
