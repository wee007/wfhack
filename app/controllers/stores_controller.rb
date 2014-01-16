class StoresController < ApplicationController

  def index
    push_centre_info_to_gon

    @grouped_stores = @stores.group_by { |store| store.first_letter }
    @letter = letter @grouped_stores
    @letters = letters @grouped_stores

    # Reduce to one if we are scoping by letter
    @grouped_stores = {@letter => @grouped_stores[@letter]} unless @letter == 'All'
    return respond_to_error 404 if @grouped_stores[@letter].blank? && @letter != 'All'

    meta.push(
      page_title: "Stores at #{centre.name}",
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

  def letters(stores)
    output = {}
    output['#'] = stores['#'].try(:length) || 0
    ('A'..'Z').inject(output) do |hash, letter|
      hash[letter] = stores[letter].try(:length) || 0
      hash
    end
    output['All'] = @stores.length if @stores.length < 100
    output
  end

  def letter(stores)
    params[:letter] || (@stores.length < 100 ? "All" : "A")
  end

end
