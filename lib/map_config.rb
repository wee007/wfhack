class MapConfig

  class << self

    def key
      '458dc5a4-547f-4fb7-a760-575d8176f70b'
    end

    def centre(centre)
      {
        'bondijunction' => 15,
        'sydney' => 30,
        'woden' => 32
      }[centre]
    end
  end

end
