require_relative '../../app/models/category.rb'

describe Category do
  
  describe '#has_code?' do
    specify do
      subject.code = 'foo'
      expect(subject.has_code?('foo')).to be_true
      expect(subject.has_code?('bar')).to be_false
    end
  end

end
