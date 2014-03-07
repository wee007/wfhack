require 'spec_helper'

describe 'curations/_tile_sidekick.html.erb' do
  let(:image_url) { 'abc.jpg' }
  let(:tile_sidekick) {{ id: 666, image_url: image_url }}
  before { view.stub(:tile_sidekick) { tile_sidekick }}
  subject { render; rendered }
  it { should match %r{#{image_url}} }
end