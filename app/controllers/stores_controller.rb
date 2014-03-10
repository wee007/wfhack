class StoresController < ApplicationController

  def index
    push_centre_info_to_gon

    store_decorator = FilteredStoresDecorator.decorate(@stores)

    @categories = RetailerCategoriesDecorator.new(store_decorator.sorted_categories, with: RetailerCategoryDecorator)
    @active_category = @categories.get(params[:category])

    # Filter the store list by params
    @stores = store_decorator.filter!(params)

    gon.filtering_by_category = !@active_category.nil?

    @show_map_on_palm = params[:map] == "true"

    title = @active_category.nil? ? "Stores at #{centre.name}" : "#{centre.name} #{@active_category.name}"
    meta.push(
      page_title: title,
      description: "Find your favourite store at #{centre.name} along with a map to help you easily find its location"
    )
  end

  def show
    return respond_to_error(404) unless store.present?
    @todays_hours = todays_hours
    @this_week_hours = this_week_hours
    push_centre_info_to_gon
    meta.push(
      page_title: "#{store.name} at #{centre.name}",
      description: store.description.try(:truncate, 156)
    )
    meta.push(social_image: store.storefront) if store.has_storefront?
  end

protected

  def todays_hours
    today = Time.now.in_time_zone(centre.timezone).strftime("%Y-%m-%d")
    StoreTradingHourService.find({store_id:store.id, centre_id: store.centre_id, from: today, to: today}).first
  end

  def this_week_hours
    StoreTradingHourService.find({store_id: store.id, centre_id: store.centre_id, to: store.this_sunday})
  rescue => error
    SplunkLogger::Logger.error \
      "StoreThisWeekHoursError",
      "store_id", store.id,
      "centre_id", store.centre_id,
      "to", store.this_sunday,
      "error", error
    []
  end

  def store
    @store ||= stores.find {|store| store.id.to_s == params[:id] }
  end

  def centre
    build_services_responses unless @centre.present?
    @centre
  end

  def stores
    build_services_responses unless @stores.present?
    @stores
  end

  def build_services_responses
    services = {
      centre: params[ :centre_id ],
      stores: { centre: params[ :centre_id ], per_page: 1000 }
    }

    if params[ :action ].eql?( 'show' )
      services[ :product ] = { action: 'lite', retailer: [ params[ :retailer_code ] ], rows: 3 }
      services[ :store ] = { centre: params[ :centre_id ], retailer_code: params[ :retailer_code ], per_page: 1000 }
    end

    @centre, @stores, @products, store = service_map services
    @deals = DealService.find( { centre: params[ :centre_id ], retailer: store.first.retailer_id, state: 'published', count: 3 } ) if store.present?
  end

  def push_centre_info_to_gon
    gon.push centre: centre
  end

end