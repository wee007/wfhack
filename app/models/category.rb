require 'hashie/mash'
class Category < Hashie::Mash
  def has_code?(code)
    code == self.code
  end
end
