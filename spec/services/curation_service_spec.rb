require 'spec_helper'

describe CurationService do

  describe '::require_uri' do
    context 'with an id' do
      subject { (described_class.request_uri 666).to_s }
      it { should match %r{/api/canned-search/master/curations/666\.json} }
    end
    context 'with no parameters' do
      subject { described_class.request_uri.to_s }
      it { should match %r{/api/canned-search/master/curations.json} }
    end
  end

  describe "::build" do
    describe 'returns an array' do
      let(:response) { double body: [{ 'code' => 'curation-1'}, { 'code' => 'curation-2' }]}
      subject { described_class.build response }
      its(:length) { should eq 2 }
      its(:first) { should be_a Curation }
      its(:last) { should be_a Curation }
    end

    describe 'returns a Curation' do
      let(:response) { double body: { 'code' => 'curation-1'}}
      subject { described_class.build response }
      it { should be_a Curation }
      its(:code) { should eq 'curation-1' }
    end
  end
end

