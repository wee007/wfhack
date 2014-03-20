require 'spec_helper'

describe 'curations/show.html.erb' do
  let(:name) { 'Curation Name' }
  let(:slug) { 'curation-code' }
  let(:links) {{ image: { href: 'abc.jpg' }}}
  let(:description) { 'Curation Description' }
  let(:curation) { Curation.new name: name, code: slug, description: description, _links: links, product_ids: []}

  subject { render; rendered }
  before { assign :curation, curation }
  it { should_not be_empty }
end
