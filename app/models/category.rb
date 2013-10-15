require 'hashie/mash'
class Category < Hashie::Mash
  def self_or_child_has_code?(code)
    has_code?(code) || child_has_code?(code)
  end

  def has_code?(code)
    code == self.code
  end

  def child_has_code?(code)
    children.any? {|child| child.has_code?(code)}
  end
end
