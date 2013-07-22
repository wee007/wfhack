require 'spec_helper'

describe VisitorsController do


  # HACK! make every request from an authenticated Customer
  before(:each) {
    session.merge!( aaa_session_atts('customer1@example.com', '') )
  }

  context "GET" do

    describe :show do

      it "renders visitor view" do
        get :show
        response.should render_template :show
      end

    end

  end

end
