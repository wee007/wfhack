module StoresHelper

  def store_phone_number(stores, retailer)
    (stores.collect(&:phone_number) << retailer.phone_number).compact.first
  end

  def letters(data, current_letter, centre)
    data.collect do |letter, count|
      has_stores = count > 0
      class_for_li = has_stores ? nil : 'is-disabled'
      class_for_a = current_letter == letter ? 'is-active' : nil

      content_tag :li, link_to_if(
        has_stores,
        letter,
        centre_stores_path(centre, letter: letter),
        class: class_for_a
      ),
      class: class_for_li
    end.join
  end

end

