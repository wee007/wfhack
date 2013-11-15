require 'spec_helper'

describe SocialSharesController do

  describe "GET #show" do

    it 'should work for products' do
      ProductService.should_receive(:find).with '1'
      get :show, id: 1, kind: 'product'
    end

    describe "scope by centre" do

      it 'should work for products' do
        ProductService.should_receive(:find).with '1'
        get :show, id: 1, kind: 'product', centre_id: 'centre_code'
      end

      it 'should work for deals' do
        DealService.should_receive(:find).with '1'
        get :show, id: 1, kind: 'deal', centre_id: 'centre_code'
      end

      it 'should work for events' do
        EventService.should_receive(:find).with '1'
        get :show, id: 1, kind: 'event', centre_id: 'centre_code'
      end

      it 'should work for canned searches' do
        CannedSearchService.should_receive(:find).with '1'
        get :show, id: 1, kind: 'canned_search', centre_id: 'centre_code'
      end

    end

  end

end