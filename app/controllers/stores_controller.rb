class StoresController < ApplicationController

  def index
    push_centre_info_to_gon

    # Categories, sorted by whether they have any sub-categories
    @categories = store_categories(@stores).sort_by {|category| !category.children.any? ? 1 : 0 }
    @categories_with_children = @categories.select{|c| c.children.any? }

    # If theres a category that has been selected
    if params[:category]
      # Filter the stores list
      @stores.delete_if{|store| !store.category_codes.include? params[:category] }

      # Get the category
      @active_category = @categories.find{ |category| category.code == params[:category] } ||
        @categories.map{|c| c.children.map{|cc| cc} }.flatten.find {|category| category.code == params[:category]}
    end

    @grouped_stores = @stores.group_by { |store| store.first_letter }

    title = @active_category.nil? ? "Stores at #{centre.name}" : "#{centre.name} #{@active_category.name}"

    meta.push(
      page_title: title,
      description: "Find your favourite store at #{centre.name} along with a map to help you easily find its location"
    )
  end

  def show
    return respond_to_error(404) unless store.present?
    push_centre_info_to_gon
    meta.push(
      page_title: "#{store.name} at #{centre.name}",
      description: store.description.try(:truncate, 156)
    )
  end

protected

  def store
    @store ||= stores.find {|store| store.id.to_s == params[:id] }
  end

  def centre
    fetch_centre_and_stores unless @centre.present?
    @centre
  end

  def stores
    fetch_centre_and_stores unless @stores.present?
    @stores
  end

  def fetch_centre_and_stores
    @centre, @stores, @products = service_map \
      centre: params[:centre_id],
      store: {centre: params[:centre_id], per_page: 1000},
      product: {action: 'lite', retailer: [params[:retailer_code]], rows: 3}
  end

  def push_centre_info_to_gon
    gon.push centre: centre
  end

private

  # Filter list of retailer categories by whether there is an associated store
  def store_categories(stores)
    # Array of categories that stores have
    store_categories = stores.map{|store| store.category_codes }.flatten.uniq

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
