require 'spec_helper'

describe NationalHelper do


  context "#national?" do

    it "should return true when we do not have a centre ivar or center_id in the params" do
      expect(helper.national?).to be_true
    end

    it "should return false when we have a centre_id param" do
      helper.stub(:params).and_return centre_id: 'bondijunction'
      expect(helper.national?).to be_false
    end

    it "should return false when we have a centre ivar" do
      assign(:centre, true)
      expect(helper.national?).to be_false
    end

  end
end
