require 'spec_helper'

describe 'layouts/_tile.html.erb' do
  let(:result) { double(kind: 'curation').as_null_object }
  let(:centre) { double }

  before do
    view.stub(:result) { result }
    assign :centre, centre
  end

  subject { render; rendered }
  it { should_not be_blank }
  specify('yields') { expect { |b| render(&b).to_yield_control.once }}
end
