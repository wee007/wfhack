class FilteredStoresDecorator < Draper::CollectionDecorator

  def filter!(options = {})
    @options = options

    by_category!
    accepting_giftcards!

    return self
  end

  def any_accepting_gift_cards?
    object.any?{|store| store.accepts_giftcards }
  end

  def in_alpha_groups
    object.group_by{|store| store.first_letter }
  end

  # Categories sorted by whether they have children or not
  def sorted_categories
    categories.sort_by {|category| !category.children.any? ? 1 : 0 }
  end

  # Filter list of all Australian retailer categories by whether there is an associated store
  def categories
    # Array of categories that stores have
    store_categories = object.map(&:category_codes).flatten

    RetailerCategoryService.find(country: 'au').map do |category|
      # Count the amount of stores that accept gift cards
      category[:stores_accepting_gift_cards] = object.count{|store| store.accepts_giftcards && store.category_codes.include?(category.code) }

      # Same for the children
      category.children.each do |child|
        number = object.count{|store| store.accepts_giftcards && store.category_codes.include?(child.code) }
        child[:stores_accepting_gift_cards] = number
      end

      # Remove children that don't match to any stores
      category.children.delete_if {|child| !store_categories.include?(child.code) }

      # If category has no children and doesn't match to any stores, remove it
      if category.children.empty? && !store_categories.include?(category.code)
        nil
      else
        category
      end

    end.compact
  end

  private

  # Filter out stores that don't match the category code
  def by_category!
    if @options.key? :category
      @object = @object.delete_if{|store| !store.category_codes.include? @options[:category] }
    end
  end

  # Filter out stores that don't accept gift cards
  def accepting_giftcards!
    if @options.key? :gift_cards
      @object = @object.delete_if{|store| !store.accepts_giftcards }
    end
  end
end