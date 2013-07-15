require 'spec_helper'
describe MoviesHelper do

  context "#days" do

    describe "When we want to days 5 days in to the future" do
      before(:each) do
        @days = days(5.days.from_now.to_s, 'bondijunction')
      end
      it "returns the days" do
        expect(@days[0]).to match("Today")
        expect(@days[1]).to match("Tomorrow")
        expect(@days[2]).to match(2.days.from_now.strftime("%A %-d"))
        expect(@days[3]).to match(3.days.from_now.strftime("%A %-d"))
        expect(@days[4]).to match(4.days.from_now.strftime("%A %-d"))
      end
    end

  end

end
