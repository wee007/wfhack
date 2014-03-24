require 'spec_helper'

describe Curation do
  let(:curation) { Curation.new }

  it { should respond_to :image }
  it { should respond_to :kind }
  it { should respond_to :products }
  it { should respond_to :retailers }
  it { should respond_to :meta }

  describe '#meta' do
    subject { curation.meta }
    its(:keys) { should match_array %w[ id title twitter_title email_body image kind social_image ]}
  end
end
