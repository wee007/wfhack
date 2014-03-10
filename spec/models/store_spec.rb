require 'spec_helper'

describe Store do

  context 'centre' do
    describe "When asking for a stores centre" do
      it "should get the centre from the centre service" do
        CentreService.stub(:fetch).with('bondijunction').and_return("CENTRE JSON")
        CentreService.stub(:build).with("CENTRE JSON").and_return(stub_centre = double(:centre).as_null_object)
        store = Store.new(:centre_id => 'bondijunction')
        expect(store.centre).to eql(stub_centre)
      end
    end
  end

  context '#first_letter' do

    it 'returns "#" when the first letter is non-alpha' do
      Store.new(name: '123').first_letter.should == '#'
    end

    it 'returns the first letter capitalized' do
      Store.new(name: 'saba').first_letter.should == 'S'
    end

    it 'ignores whitespace' do
      Store.new(name: ' saba').first_letter.should == 'S'
    end

  end

  context '#logo' do

    let(:logo_url) { '' }
    let(:store_attrs) { Hashie::Mash.new _links: {logo: {href: logo_url}} }

    subject { Store.new store_attrs }

    it { should_not have_logo }

    describe 'with logo' do

      let(:logo_url) { 'http://some.logo.com' }

      it { should have_logo }

      it 'returns the contents of _links.logo.ref' do
        subject.logo.should =~ /#{logo_url}/
      end

    end

  end

  describe "#this_sunday" do
    let(:centre) { Hashie::Mash.new(id: 'sydney', timezone: 'Australia/Sydney') }
    let(:store) { Hashie::Mash.new(id: 1, centre_id: 'sydney') }
    let(:this_monday) do
      Date.commercial(Date.today.year, Date.today.cweek, 1).in_time_zone(centre.timezone)
    end

    subject { Store.new(store) }

    it "returns the date of this Sunday" do
      CentreService.stub(:fetch).with('sydney').and_return("centre JSON")
      CentreService.stub(:build).with("centre JSON").and_return(centre)
      expect(subject.this_sunday).to eq((this_monday+6.days).strftime("%Y-%m-%d"))
    end
  end

end