require 'spec_helper'

describe CampaignService do

  describe "#require_uri" do
    subject { (described_class.request_uri centre: 'burwood').to_s }
    it { should eq "http://deal-service.test.dbg.westfield.com/api/deal/master/campaigns.json?centre=burwood" }
  end

  describe "#build" do
    let(:json_response) { double body: [{ "title" => "campaign-1" }]}
    subject { described_class.build json_response }
    its(:size) { should eq 1 }
    its(:first) { should eq Campaign.new title: "campaign-1" }
  end
end
