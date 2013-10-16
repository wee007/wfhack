require 'hashie/mash'

class Category < Hashie::Mash
  def has_code?(code)
    code == self.code
  end

  def to_param
    code
  end
end
