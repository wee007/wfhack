require 'spec_helper'

describe VisitorController do


  # HACK! make every request from an authenticated Customer
  before(:each) {
    session.merge!( aaa_session_atts('customer1@example.com', '') )
  }

  context "GET" do

    describe :index do

      it "renders visitor view" do
        get :index
        response.should render_template :index
      end

    end

  end

end
