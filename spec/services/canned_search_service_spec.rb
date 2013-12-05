require 'spec_helper'
describe CannedSearchService do

  context "#request_uri" do

    subject { CannedSearchService.request_uri(data).to_s }

    describe "resouce" do
      let(:data) { 1 }
      it { should include "canned_searches/1.json" }
    end

    describe "collection" do
      let(:data) { nil }
      it { should include "canned_searches.json" }
    end

    describe "collection with params" do
      let(:data) { {country: 'au'} }
      it { should include "canned_searches.json?country=au" }
    end

  end

  context "#build" do

    subject { CannedSearchService.build data }

    describe "resouce" do
      let(:data) { {test: 123} }
      it { should be_an(CannedSearch) }
    end

    describe "collection" do
      let(:data) { [{test: 123}] }
      it { should be_an(Array) }
      it { subject.each{ |canned_search| canned_search.should be_an(CannedSearch) } }
    end

  end

end
