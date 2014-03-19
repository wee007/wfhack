require 'spec_helper'

describe Curation do
  it { should respond_to :image }
  it { should respond_to :kind }
  it { should respond_to :products }
  it { should respond_to :retailers }
end
