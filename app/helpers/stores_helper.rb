module StoresHelper

  def filtering_gift_cards?
    params[:gift_cards] and params[:gift_cards] == 'true'
  end

  def empty_category?(category)
    filtering_gift_cards? and category.gift_card_store_count < 1
  end

  def store_phone_number(stores, retailer)
    (stores.collect(&:phone_number) << retailer.phone_number).compact.first
  end
end

