class StoresController < ApplicationController

  def index
    push_centre_info_to_gon

    stores_decorator = FilteredStoresDecorator.decorate(@stores)

    @categories = stores_decorator.sorted_categories
    @categories_with_children = @categories.select{|c| c.children.any? }

    # If theres a category that has been selected
    if params[:category]
      # Filter the stores list
      @stores = stores_decorator.by_category(params[:category])

      # Get the category
      @active_category = (@categories + @categories.map{|c| c.children}).flatten.find {|category| category.code == params[:category]}
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
end
