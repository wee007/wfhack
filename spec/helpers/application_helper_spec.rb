require 'spec_helper'

describe ApplicationHelper do

  describe :twelve_hour_format do
    context "when 24 hour format on am is passed as argument" do
      it "returns 12 hour format with am appended" do
        helper.twelve_hour_format("09:00:00").should eq "9:00am"
      end
    end

    context "when 24 hour format on pm is passed as argument" do
      it "returns 12 hour format with pm appended and only shows the hour" do
        helper.twelve_hour_format("17:00:00").should eq "5:00pm"
      end
    end

    context "when invalid time is passed as argument" do
      it "returns nil" do
        helper.twelve_hour_format("").should eq nil
      end
    end
  end

end
