require 'spec_helper'
describe ImageService do

  subject { ImageService }

  it 'generates default image url' do
    expect(subject.transform ref: 'ref').to eq(
      "#{subject.url}/transform?ref=ref&size=100x100"
    )
  end

  it 'generates image url' do
    expect(subject.transform ref: 'ref', width: 100, height: 100).to eq(
      "#{subject.url}/transform?ref=ref&size=100x100"
    )
  end

  it 'generates image url, with only width passed' do
    expect(subject.transform ref: 'ref', width: 300).to eq(
      "#{subject.url}/transform?ref=ref&size=300x300"
    )
  end

  it 'generates image url, with only height passed' do
    expect(subject.transform ref: 'ref', height: 400).to eq(
      "#{subject.url}/transform?ref=ref&size=400x400"
    )
  end

  it 'generates responsive image url' do
    expect(subject.transform ref: 'ref', width: 100, height: 100, responsive: true).to eq(
      "#{subject.url}/transform?quality=25&ref=ref&size=200x200"
    )
  end

  it 'generates responsive image url, with only width passed' do
    expect(subject.transform ref: 'ref', width: 400, responsive: true).to eq(
      "#{subject.url}/transform?quality=25&ref=ref&size=800x800"
    )
  end

  it 'generates responsive image url, with only height passed' do
    expect(subject.transform ref: 'ref', height: 400, responsive: true).to eq(
      "#{subject.url}/transform?quality=25&ref=ref&size=800x800"
    )
  end

end
