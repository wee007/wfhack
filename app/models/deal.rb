class Deal < OpenStruct

  def retailer_logo_url
    store._links.logo.href
  end

  def store_name
    store.name
  end

private
  def store
    @store ||= get_store
  end

  def get_store
    store_service = StoreService.fetch(deal_stores.first.store_service_id)
    StoreService.build store_service
  end

end