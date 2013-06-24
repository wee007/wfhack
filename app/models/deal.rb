class Deal < OpenStruct

  def retailer_logo_url
    store_service = StoreService.fetch(deal_stores.first.store_service_id)
    store = StoreService.build store_service
    store._links.logo.href
  end

end