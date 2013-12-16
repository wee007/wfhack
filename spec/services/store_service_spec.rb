require 'spec_helper'
describe StoreService do
  describe "When getting a cinema_id for belconnen" do
    subject { StoreService.cinema_id_for_centre('belconnen') }
    it { should eql(17453) }
  end

  describe "When asking for a cinema_id from a centre that doesn't have one" do
    subject { StoreService.cinema_id_for_centre('not_found') }
    it { should be_nil }
  end
end
