require 'spec_helper'
describe StoresHelper do

  describe "#letters" do
    let(:current_letter) { "B" }
    let(:data) { {"A" => 1, "B" => 22, "C" => 0, "D" => 100} }
    let(:centre) { 'northrocks' }
    subject { letters data, current_letter, centre }

    it {should include(%{<li><a href="/northrocks/stores?letter=A">A</a></li>}) }
    it {should include(%{<a class="is-active" href="/northrocks/stores?letter=B">B</a>}) }
    it {should include(%{<li class="is-disabled">C</li>}) }
  end

end