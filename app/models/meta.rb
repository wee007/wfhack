class Meta < Hashie::Mash

  def push(to_add)
    self.merge! to_add
  end

  def to_hash
    super.merge({page_title: page_title, description: description})
  end

end