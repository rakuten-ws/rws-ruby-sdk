module RakutenWebService
  class Response
    include Enumerable

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

    def each
      @resource_class.parse_response(@json).each do |resource|
        yield resource
      end
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
