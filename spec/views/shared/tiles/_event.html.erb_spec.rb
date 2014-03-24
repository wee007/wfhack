require 'spec_helper'

describe 'shared/tiles/_curation.html.erb' do
  let(:url) { 'abc.jpg' }
  let(:name) { 'curation-name' }

  let(:curation) { Curation.new name: name, _links: { image: { href: url }}}

  before { view.stub(:result) { curation }}

  subject { render; rendered }
  it { should_not be_blank }
  it { should have_css 'img[src$="abc.jpg"]' }
  it { should have_css 'h3', text: name }
end
