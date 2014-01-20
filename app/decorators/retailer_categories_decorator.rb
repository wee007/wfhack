class RetailerCategoriesDecorator < Draper::CollectionDecorator
  def get(code)
    categories = (object + object.map(&:children)).flatten
    categories.find {|category| category.code == code}
  end

  def with_children
    object.select{|c| c.children.any? }
  end
end