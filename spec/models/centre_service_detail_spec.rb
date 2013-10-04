require "spec_helper"

describe CentreServiceDetail do
  describe :service_type_details do
    let(:service_details) {
      {
        centre_id: 'chatswood',
        details: [
          {
            type: 'concierge',
            description: 'some gibberish',
            phone_no: 'a phone number'
          },
          {
            type: 'giftcard',
            description: 'some gibberish',
            phone_no: 'a phone number'
          }
        ]
      }
    }

    subject { CentreServiceDetail.new(service_details) }

    context 'when requesting for details for a given service type' do
      it { subject.service_type_details('concierge').should eql(subject[:details][0]) }
    end
  end
end