module RakutenWebService
  class Response
    def initialize(resource_class, json)
      @resource_class = resource_class
      @json = json.dup
    end

    def [](key)
      @json[key]
    end

    def []=(key, value)
      @json[key] = value
    end

    def page
      @json['page']
    end

    def has_next_page?
      page && (not last_page?)
    end

    def last_page?
      page >= @json['pageCount']
    end
  end
end
