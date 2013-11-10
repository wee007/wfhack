require 'spec_helper'
require 'vcr_helper'

describe "Parking" do

  before(:each) do
    CentreServiceNoticesService.stub(:fetch)
  end
  

  describe "a centre without parking" do
    before(:each) do
      VCR.use_cassette('knox_without_parking') do
        get centre_info_path(centre_id: 'knox')
      end
    end
    it "should not show any parking" do
      assert_select "h2#parking", count: 0
    end
  end

  describe "a centre with complimentary parking" do
    before(:each) do
      VCR.use_cassette('caseycentral_with_complimetary_parking') do
        get centre_info_path(centre_id: 'caseycentral')
      end
    end
    it "should say the parking is free" do
      assert_select 'h2', 'Parking'
      assert_select 'p', 'Complimentary parking available for all customers.'
    end
  end

  describe "a centre with parking rates" do
    before(:each) do
      VCR.use_cassette('doncaster_parking_with_rates') do
        get centre_info_path(centre_id: 'doncaster')
      end
    end

    it "should show all the parking rates" do
      assert_select '#parking-rates' do
        assert_select 'td.test-times', "0 &#8211; 3hrs"
        assert_select 'td.test-weekday', "FREE"
        assert_select 'td.test-weekend', "FREE"

        assert_select 'td.test-times', "3 &#8211; 5hrs"
        assert_select 'td.test-weekday', "$5"
        assert_select 'td.test-weekend', "$5"

        assert_select 'td.test-times', "5 &#8211; 7hrs"
        assert_select 'td.test-weekday', "$10"
        assert_select 'td.test-weekend', "$10"
      end
    end

    it "have a link to the terms and conditions" do
      assert_select 'a.test-terms-link[href=?]', 'http://res.cloudinary.com/wlabs/image/upload/df4zc8o8cxd4u8oxvqhb.pdf'
    end
  end

  describe "a centre a fixed rate" do
    before(:each) do
      VCR.use_cassette('warringahmall_fixed_rate') do
        get centre_info_path(centre_id: 'warringahmall')
      end
    end
    it "should say the parking is fixed rate" do
      assert_select 'h2', 'Parking'
      assert_select 'p', "Fixed Parking rate of $5 per day"
    end
  end

end
