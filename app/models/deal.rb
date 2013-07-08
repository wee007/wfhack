class Deal < OpenStruct

  def retailer_logo_url
    store._links.logo.href
  end

  def store_name
    store.name
  end

  def stores
    deal_stores.map do |deal_store|
      Store.new(deal_store)
    end
  end

  def terms_and_conditions
    (super || '').split(/\r?\n/)
  end

  def available_to
    DateTime.parse(super)
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