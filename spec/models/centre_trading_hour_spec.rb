require "spec_helper"

# if standard hours week starts matches xmas hours week start then remove the standard hours week

describe CentreTradingHour do

  subject { CentreTradingHour }
  let :not_christmas do
    {
      standard_hours: [
        {monday: {date: "2013-12-25"}},
        {monday: {date: "2013-12-25"}}
      ],
      christmas_hours: [[{date: "2013-12-25"}]]
    }
  end

  context :standard_hours do
    it "should return 2 weeks" do
      centre_trading_hours = subject.new not_christmas
      expect(centre_trading_hours.standard_hours).to be_nil
    end
  end

  context :christmas_hours do
    it "should return nil" do
      centre_trading_hours = subject.new not_christmas
      expect(centre_trading_hours.christmas_hours.size).to be_nil
    end
  end

end