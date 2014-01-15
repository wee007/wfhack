require 'spec_helper'
require 'vcr_helper'

describe 'Deals' do

  describe 'sub-navigation bar' do

    context 'when a campaign exists' do

      let( :campaign_param ) { { centre: 'sydney' } }
      let( :campaign_response ) { double( :campaign_response ).as_null_object }
      let( :campaign ) { [ Hashie::Mash.new( code: 'campaign-code' ) ] }

      before( :each ) do
        CampaignService.stub( :fetch ).with( campaign_param ).and_return( campaign_response )
        CampaignService.stub( :build ).and_return( campaign )

        VCR.use_cassette( 'sydney_with_campaign' ) { get centre_deals_path( centre_id: 'sydney' ) }
      end

      it 'should show the sub-navigation bar' do
        assert_select( 'div.section-nav', count: 1 )
      end

    end

    context 'when a campaign does not exists' do

      let( :deal_params ) do
        {
          centre: 'sydney',
          state: 'published',
          rows: 50
        }
      end
      let( :deal_response ) { double( :deal_response ).as_null_object }
      let( :deal ) { double( :deal ).as_null_object }

      before( :each ) do
        DealService.stub( :fetch ).with( deal_params ).and_return( deal_response )
        DealService.stub( :build ).and_return( deal )

        VCR.use_cassette( 'sydney_with_no_campaign' ) { get centre_deals_path( centre_id: 'sydney' ) }
      end

      it 'should not show the sub-navigation bar' do
        assert_select( 'div.section-nav', count: 0 )
      end

    end

  end

end