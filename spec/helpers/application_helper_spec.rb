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

  describe "#canonical_url" do
    context "when params are present" do
      let(:canonical_url) { 'http://some_url?param_one=some_value&param_two=some_value' }
      it "returns the canonical URL with params" do
        helper.stub(:params).and_return(param_one: 'some_value', param_two: 'some_value')
        helper.stub(:url_for).with(only_path: false, param_one: 'some_value', param_two: 'some_value').and_return(canonical_url)
      end
    end
    context "when Google Experiment params are present" do
      let(:canonical_url) { 'http://some_url?other_param=some_value' }
      it "returns the canonical URL with all the params except for Google Experiment ones" do
        helper.stub(:params).and_return(gce_var: '1', utm_expid: '1', utm_referrer: 'some_url')
        helper.stub(:url_for).with(only_path: false, other_param: 'some_value').and_return(canonical_url)
      end
    end
  end

  describe "#except_google_experiment_params" do
    context "when Google Experiment params are NOT present" do
      it "returns all the params" do
        helper.stub(:params).and_return(param_one: 'some_value', param_two: 'some_value')
        expect(helper.except_google_experiment_params).to eql(param_one: 'some_value', param_two: 'some_value')
      end
    end
    context "when Google Experiment params are present" do
      it "returns all the params except for the Google Experiment ones" do
        helper.stub(:params).and_return(gce_var: '1', utm_expid: '1', utm_referrer: 'some_url', other_param: 'some_value')
        expect(helper.except_google_experiment_params).to eql(other_param: 'some_value')
      end
    end
  end

end
