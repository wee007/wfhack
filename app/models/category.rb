require 'hashie/mash'

class Category < Hashie::Mash
  def has_code?(code)
    code == self.code
  end

  def to_param
    code
  end

  def short_name
    self.fetch(:short_name, compute_short_name)
  end

  private
  def compute_short_name
    self.name.split(' ').first
  end
end
