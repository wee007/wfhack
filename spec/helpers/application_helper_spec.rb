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

  describe "#phone_format" do

    phone_numbers = [
      '02 1234 123456',
      '03 1234 123456',
      '06 1234 123456',
      '07 1234 123456',
      '08 1234 123456',
      '1234 123 123',
      '1234 5678',
      '123 123',
      '0412 123 123456',
      '(02)1234-123456'
    ]

    phone_numbers.each do |format|
      number = format.gsub(/\s+/, '')
      
      it "formats '#{number}' as '#{format}'" do
        expect(helper.phone_format(number)).to eql(format)
      end
    end

  end

  describe "#phone_link" do

    it "creates a phone number link for mobile" do
      expect(
        helper.phone_link('02 1234 123456') {|phone| "Number: #{phone}"}
      ).to match(/href="tel:021234123456".*Number: 02 1234 123456/)
    end
  end

  describe :active_link? do

    context "when string matches param value" do
      it "returns the is_active class" do
        expect( helper.active_link?( "Westfield", "Westfield" ) ).to eql( 'is-active' )
      end
    end

    context "when string does not match param value" do
      it "returns no class" do
        expect( helper.active_link?( "Westfield", "Stockland" ) ).to eql( nil )
      end
    end

  end

end
