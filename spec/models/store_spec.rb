require 'spec_helper'

describe Store do

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

    let(:logo) { 'my test logo' }
    let(:store_attrs) { Hashie::Mash.new _links: {logo: {href: logo}} }

    subject { Store.new store_attrs }

    it 'returns the contents of _links.logo.href' do
      subject.logo.should == logo
    end

  end

end
