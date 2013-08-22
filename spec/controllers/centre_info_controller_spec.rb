require 'spec_helper'

describe CentreInfoController do

  context "GET" do
    describe :show do

      it "renders show view" do
        CentreService.should_receive( :fetch ).with('chatswood').and_return double :response, body: {}
        get :show, centre_id: 'chatswood'
        response.should render_template :show
      end

    end
  end
end
