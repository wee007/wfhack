require_relative '../../app/models/category.rb'

describe Category do
  
  describe '#self_or_child_has_code?' do

    let(:parent_code)     { 'parent-code' }
    let(:child_code)      { 'child-code' }
    let(:unmatched_code)  { 'unmatched_code' }

    before do
      subject.stub(:child_has_code?).with(unmatched_code) { false }
      subject.stub(:child_has_code?).with(parent_code) { false }
      subject.stub(:child_has_code?).with(child_code) { true }
      subject.stub(:has_code?).with(unmatched_code) { false }
      subject.stub(:has_code?).with(parent_code) { true }
      subject.stub(:has_code?).with(child_code) { false }
    end

    it 'returns true when self has_code?' do
      expect(subject.self_or_child_has_code?(parent_code)).to be_true
    end
    it 'returns true when child has_code?' do
      expect(subject.self_or_child_has_code?(child_code)).to be_true
    end
    it 'returns false when neither match' do
      expect(subject.self_or_child_has_code?(unmatched_code)).to be_false
    end
  end

  describe '#has_code?' do
    specify do
      subject.code = 'foo'
      expect(subject.has_code?('foo')).to be_true
      expect(subject.has_code?('bar')).to be_false
    end
  end

  describe '#child_has_code?' do
    specify do
      child = double(:child)
      child.stub(:has_code?).with('foo') { true }
      child.stub(:has_code?).with('bar') { false }
      subject.stub(:children => [child])
      expect(subject.child_has_code?('foo')).to be_true
      expect(subject.child_has_code?('bar')).to be_false
    end
  end
end
