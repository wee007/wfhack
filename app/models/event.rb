class Event < Hashie::Mash

  # TODO: remove this
  def title
    super || name
  end

  def start_date(format_string = :raw)
    occurrences.first.start(format_string)
  end

  def end_date(format_string = :raw)
    occurrences.last.finish(format_string)
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

  def multiple_occurrences_on_same_day?
    event_times_grouped_by_date.length == 1
  end

  def event_times_grouped_by_date
    occurrences.inject({}) do |acc, occurrence|
      start_date = Date.parse(occurrence.start)
      (acc[start_date] ||= []) << occurrence
      acc
    end
  end

  def occurrences
    @occurrences ||= super.collect {|occurrence| Occurrence.new(start: occurrence.start,
                                                                finish: occurrence.finish,
                                                                timezone: self.timezone)}
  end

  def kind
    self.class.name.downcase
  end

  def meta
    Meta.new title: title,
             twitter_title: "Check out this #{title}",
             email_body: "event",
             image: image
  end

  class Occurrence < Hashie::Mash
    def start(format_string = :raw)
      # make sure we display the date in the timezone of the centre
      # the event belongs to.  Timezone is retrieved from the centre and
      # passed to Occurrence object when it's instanciated
      parsed_time = Time.zone.parse(super).in_time_zone(timezone).to_s(format_string)
      (format_string == :raw) ? super : parsed_time
    end

    def finish(format_string = :raw)
      parsed_time = Time.zone.parse(super).in_time_zone(timezone).to_s(format_string)
      (format_string == :raw) ? super : parsed_time
    end    
  end

end
