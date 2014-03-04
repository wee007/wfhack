class Deal < OpenStruct

  class State
    Scheduled = 'scheduled'
    Live = 'live'
  end

  attr_accessor :store

  # TODO: remove this
  def title
    super || name
  end

  def store_name
    store.name
  end

  def retailer_code
    store.retailer_code
  end

  def logo
    store.logo if store && store.has_logo?
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

  def available_from
    DateTime.parse(super)
  end

  def published?
    [ State::Scheduled, State::Live ].include? state
  end

  def to_param
    id
  end

  def kind
    self.class.name.downcase
  end

  def meta
    Meta.new id: id,
             title: title,
             twitter_title: "Check out this deal",
             email_body: "deal",
             kind: kind
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
