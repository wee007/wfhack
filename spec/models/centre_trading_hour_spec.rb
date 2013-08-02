require "spec_helper"

describe CentreTradingHour do

  describe "#christmas?" do
    subject { CentreTradingHour.new(christmas).christmas? }
    let(:christmas) { {hour_type: 'christmas'} }
    it { should be_true }
  end

  describe "weeks" do
    subject { CentreTradingHour.weeks(data).length }
    let(:christmas) { [double('christmas?' => true)] * 7 }
    let(:default) { [double('christmas?' => false)] * 7 }

    context "not the christmas period" do
      let(:data) { default * 6 }
      it { should eql(2) }
    end

    context "the christmas period is in 2 weeks" do
      let(:data) { default * 2 + christmas * 4 }
      it { should eql(6) }
    end

    context "the christmas period is in 1 weeks" do
      let(:data) { default * 1 + christmas * 4 + default * 1 }
      it { should eql(5) }
    end

    context "in the christmas period, week 1" do
      let(:data) { christmas * 4 +  default * 2 }
      it { should eql(4) }
    end

    context "in the christmas period , week 2" do
      let(:data) { christmas * 3 +  default * 3 }
      it { should eql(3) }
    end

    context "in the christmas period , week 3" do
      let(:data) { christmas * 2 +  default * 4 }
      it { should eql(2) }
    end

    context "in the christmas period, week 4" do
      let(:data) { christmas * 1 +  default * 5 }
      it { should eql(2) }
    end

  end

end