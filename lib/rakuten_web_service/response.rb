module RakutenWebService
  class Response
    def initialize(json)
      @json = json.dup
    end

    def [](key)
      @json[key]
    end

    def []=(key, value)
      @json[key] = value
    end

    def has_next_page?
      page && (page < @json['pageCount'])
    end

    def page
      @json['page']
    end
  end
end
