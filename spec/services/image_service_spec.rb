require 'spec_helper'
describe ImageService do

  subject { ImageService }

  it 'generates image url' do
    expect(subject.transform ref: 'ref', size: 'size').to eq "#{subject.url}/transform?ref=ref&size=size"
  end

end
