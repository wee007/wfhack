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
    end

    it "should assign a centre" do
      get :index, centre_id: 'bondijunction'
      assigns(:centre).should_not be_nil
    end

    it "should assign a grouped_stores" do
      get :index, centre_id: 'bondijunction'
      assigns(:grouped_stores).should eql({"A" => stores})
    end

    it "should assign a letters" do
      get :index, centre_id: 'bondijunction'
      assigns(:letters)["A"].should eql(1)
      assigns(:letters)["B"].should eql(0)
      assigns(:letters)["All"].should eql(1)
    end

    context "letter" do

      it "should assign A as the letter" do
        get :index, centre_id: 'bondijunction', letter: 'A'
        assigns(:letter).should eql('A')
      end

      it "should assign All as the letter" do
        get :index, centre_id: 'bondijunction'
        assigns(:letter).should eql('All')
      end

      it "should assign All as the letter" do
        controller.instance_variable_set :@stores, many_stores
        get :index, centre_id: 'bondijunction'
        assigns(:letter).should eql('A')
      end
    end

    context "response codes" do

      it "should be 200" do
        get :index, centre_id: 'bondijunction'
        response.response_code.should eql 200
      end

      it "should be 200" do
        get :index, centre_id: 'bondijunction', letter: 'A'
        response.response_code.should eql 200
      end

      it "should be 200" do
        get :index, centre_id: 'bondijunction', letter: 'All'
        response.response_code.should eql 200
      end

      it "should be 404" do
        get :index, centre_id: 'bondijunction', letter: 'invalid'
        response.response_code.should eql 404
      end

    end

  end
end