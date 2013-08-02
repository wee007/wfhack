require "spec_helper"

describe CentreTradingHour do

  describe "#christmas?" do
    subject { CentreTradingHour.new(christmas).christmas? }
    let(:christmas) { {hour_type: 'christmas'} }
    it { should be_true }
  end

end