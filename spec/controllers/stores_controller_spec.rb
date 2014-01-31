require 'spec_helper'

describe StoresController do

  describe "GET #index" do

    let(:stores) { [double(:store, first_letter: 'A').as_null_object] }
    let(:many_stores) do
      (0..100).collect do
        letter = ('A'..'Z').to_a.sample(1)
        double(:store, first_letter: letter).as_null_object
      end
    end

    before :each do
      controller.stub :build_services_responses
      controller.instance_variable_set :@centre, double.as_null_object
      controller.instance_variable_set :@stores, stores
      
      RetailerCategoryService.stub(:find).and_return([])
    end

    it "should assign a centre" do
      get :index, centre_id: 'bondijunction'
      assigns(:centre).should_not be_nil
    end

    context "response codes" do

      it "should be 200" do
        get :index, centre_id: 'bondijunction'
        response.response_code.should eql 200
      end

    end

  end

  describe :build_services_responses do

    let( :store_attributes ) do
      {
        id: 1,
        retailer_id: 1,
        retailer_code: 'abc',
        centre_id: 'sydney',
        name: 'ABC',
        description: 'blah',
        category_codes: nil
      }
    end

    let( :centre_param ) { 'sydney' }
    let( :centre_response ) { double( :centre_response ).as_null_object }
    let( :centre ) { double( :centre ).as_null_object }

    let( :stores_params ) { { centre: 'sydney', per_page: 1000 } }
    let( :stores_response ) { double( :store_response ).as_null_object }
    let( :stores ) { [ double( :stores, store_attributes ) ] }

    let( :product_params ) { { action: 'lite', retailer: [ 'abc' ], rows: 3 } }
    let( :product_response ) { double( :product_response ).as_null_object }
    let( :products ) { [ double( :products ).as_null_object ] }

    let( :store_params ) { { centre: 'sydney', retailer_code: 'abc',  per_page: 1000 } }
    let( :store_response ) { double( :store_response ).as_null_object }
    let( :store ) { [ double( :store, store_attributes ) ] }

    let( :deal_params ) { { centre: 'sydney', retailer: 1, state: 'published', count: 3 } }
    let( :deal_response ) { double( :deal_response ).as_null_object }
    let( :deals ) { [ double( :deals ).as_null_object ] }

    before do
      CentreService.stub( :fetch ).with( centre_param ).and_return( centre_response )
      CentreService.stub( :build ).and_return( centre )

      StoreService.stub( :fetch ).with( stores_params ).and_return( stores_response )
      StoreService.stub( :build ).and_return( stores )
    end

    context "when on index page" do

      before do
        RetailerCategoryService.stub( :find ).and_return( [] )

        get :index, centre_id: 'sydney'
      end

      specify { expect( assigns( :centre ) ).to eq( centre ) }
      specify { expect( assigns( :stores ) ).to eq( stores ) }
      specify { expect( assigns( :products ) ).to eq( nil ) }
      specify { expect( assigns( :store ) ).to eq( nil ) }
      specify { expect( assigns( :deal ) ).to eq( nil ) }

    end

    context "when on show page" do

      before do
        ProductService.stub( :fetch ).with( product_params ).and_return( product_response )
        ProductService.stub( :build ).and_return( products )

        StoreService.stub( :fetch ).with( store_params ).and_return( store_response )
        StoreService.stub( :build ).and_return( store )

        DealService.stub( :fetch ).with( deal_params ).and_return( deal_response )
        DealService.stub( :build ).and_return( deals )

        get :show, centre_id: 'sydney', retailer_code: 'abc', id: 1
      end

      specify { expect( assigns( :centre ) ).to eq( centre ) }
      specify { expect( assigns( :stores ) ).to eq( store ) }
      specify { expect( assigns( :products ) ).to eq( products ) }
      specify { expect( assigns( :store ) ).to eq( store.first ) }
      specify { expect( assigns( :deals ) ).to eq( deals ) }

    end

  end

end