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

  describe :this_week_hours do
    let(:centre) { Hashie::Mash.new(id: 'sydney', timezone: 'Australia/Sydney') }

    before(:each) do
      controller.stub(:build_services_responses)
      controller.instance_variable_set(:@centre, centre)
    end

    context "when no hours exist for a store" do
      before(:each) { controller.instance_variable_set(:@stores, double.as_null_object) }

      it "returns an empty array indicating no hours found" do
        get :show, centre_id: 'sydney', retailer_code: 'retailer_code', id: 1
        expect(controller.send(:this_week_hours)).to eq([])
      end
    end

    context "when more than one week of hours exist for a store" do
      def create_two_weeks_of_hours
        (0..13).each_with_index do |hour, index|
          StoreTradingHour.new({store_id: stores.first.id, day_of_week: index})
        end
      end

      let(:this_sunday) do
        this_monday = Date.commercial(Date.today.year, Date.today.cweek, 1).in_time_zone(centre.timezone)
        (this_monday+6.days).strftime("%Y-%m-%d")
      end
      let(:stores) do
        [
          Hashie::Mash.new(
            id: 1,
            retailer_id: 1,
            centre_id: 'sydney',
            retailer_code: 'retailer_code',
            this_sunday: this_sunday
          )
        ]
      end
      let(:one_week_of_hours_params) do
        {
          store_id: stores.first.id,
          centre_id: stores.first.centre_id,
          to: this_sunday
        }
      end
      let(:one_week_of_hours) do
        one_week_of_hours = []
        (0..6).each_with_index do |hour, index|
          one_week_of_hours << Hashie::Mash.new(store_id: stores.first.id, day_of_week: index)
        end
        one_week_of_hours
      end

      before(:each) do
        create_two_weeks_of_hours
        controller.stub(:todays_hours)
        controller.instance_variable_set(:@stores, stores)
        StoreTradingHourService.stub(:find)
          .with(one_week_of_hours_params)
          .and_return(one_week_of_hours)
      end

      it "returns this week hours only" do
        get :show, centre_id: 'sydney', retailer_code: 'retailer_code', id: 1
        expect(controller.send(:this_week_hours)).to eq(one_week_of_hours)
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
    let( :stores ) { [ double( :stores, store_attributes ).as_null_object ] }

    let( :product_params ) { { action: 'lite', retailer: [ 'abc' ], rows: 3 } }
    let( :product_response ) { double( :product_response ).as_null_object }
    let( :products ) { [ double( :products ).as_null_object ] }

    let( :store_params ) { { centre: 'sydney', retailer_code: 'abc',  per_page: 1000 } }
    let( :store_response ) { double( :store_response ).as_null_object }
    let( :store ) { [ double( :store, store_attributes ).as_null_object ] }

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

        StoreTradingHourService.stub( :fetch )
        StoreTradingHourService.stub( :build ).and_return([])

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