require 'spec_helper'

describe 'events/show.html.erb' do
  describe "occurrences' dates" do
    let(:start) { '2014-03-08T09:02+04:00' } # 9:02am in timezone +4 hours
    let(:finish) { '2014-04-21T17:15+11:00' } # 5:15pm in timezone +11 hours
    let(:occurrence) {{ start: start, finish: finish }}
    let(:links) {{ image: { href: '' } }}
    let(:event) { Event.new occurrences: [ occurrence ], _links: links }
    before { assign :event, event }

    subject { render; rendered }
    it { should match %r{9:02am} }
    it { should match %r{5:15pm} }
  end
end
