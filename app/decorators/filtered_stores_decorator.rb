class FilteredStoresDecorator < Draper::CollectionDecorator

  def by_category(category)
    object.dup.delete_if{|store| !store.category_codes.include? category }
  end

  # Categories sorted by whether they have children or not
  def sorted_categories
    categories.sort_by {|category| !category.children.any? ? 1 : 0 }
  end

  # Filter list of all Australian retailer categories by whether there is an associated store
  def categories
    # Array of categories that stores have
    store_categories = object.map{|store| store.category_codes }.flatten.uniq

    RetailerCategoryService.find(country: 'au').map do |category|
      # Remove children that don't match to any stores
      category.children.delete_if {|child| !store_categories.include?(child.code) }

      # If category has no children and doesn't match to any stores, remove it
      if store_categories.include?(category.code)
        category
      else
        nil
      end
    end.compact
  end
end