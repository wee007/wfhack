require 'spec_helper'

describe CentreServiceDetailsController do
  let(:service_details) {
    {
      centre_id: 'chatswood',
      details: [
        {
          type: 'concierge',
          description: 'some gibberish',
          phone_no: 'a phone number'
        }
      ]
    }
  }

  before :each do
    CentreService.stub(:fetch).and_return(double :response, body: { name: 'Westfield Chatswood' })
    CentreServiceDetailService.stub(:fetch).and_return(double :response, body: service_details)
  end

  describe :show do
    context "when requesting for centre service details" do
      it "renders show view" do
        get :show, centre_id: 'chatswood'
        response.should render_template :show
      end
    end

    context "when requesting for meta data" do
      it "adds page title and description to meta" do
        meta_double = double :meta
        meta_double.should_receive(:push).with({
          page_title: 'Westfield Chatswood Centre Services',
          description: 'Centre Concierge, Giftcards and a list of services available at Westfield Chatswood'
        })

        controller.stub(:meta).and_return(meta_double)
        get :show, centre_id: 'chatswood'
      end
    end
  end
end
