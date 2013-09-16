require 'spec_helper'
describe ParkingsHelper do
  context "#display_parking_rate" do
    describe "when the rate is zero" do
      it "should return FREE" do
        expect(display_parking_rate(0.0)).to eql('FREE')
      end
    end
    describe "When the rate is above zero" do
      it "should return a dollar value" do
        expect(display_parking_rate(10.23)).to eql("$10.23")
      end
    end
  end
end
