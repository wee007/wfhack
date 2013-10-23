class Event < Hashie::Mash

  # TODO: remove this
  def title
    super || name
  end

  def date(format_string = :raw)
    (format_string == :raw) ? super : Time.parse(super).to_s(format_string)
  end

  def end_date(format_string = :raw)
    (format_string == :raw) ? super : Time.parse(super).to_s(format_string)
  end

  def body
    (super || '').split(/\r?\n/).collect &:strip
  end

  def image
    _links['image']['href']
  end

  def to_param
    id
  end

  def multiple_occurrences?
    occurrences.present? && occurrences.length > 1
  end

  def event_times_grouped_by_date
    occurrences.inject({}) do |acc, occurrence|
      start_date = Date.parse(occurrence[:start])
      (acc[start_date] ||= []) << Occurrence.new(occurrence)
      acc
    end
  end

  def kind
    self.class.name.downcase
  end

  def meta
    Meta.new title: title,
             image: image
  end

  class Occurrence < Hashie::Mash
    def start(format_string = :raw)
      (format_string == :raw) ? super : Time.parse(super).to_s(format_string)
    end

    def finish(format_string = :raw)
      (format_string == :raw) ? super : Time.parse(super).to_s(format_string)
    end    
  end

end
