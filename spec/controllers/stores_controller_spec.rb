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
      controller.stub :fetch_centre_and_stores
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
end