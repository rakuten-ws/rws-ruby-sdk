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

    def each
      resources.each do |resource|
        yield resource
      end
    end

    %w(count hits page first last carrier pageCount).each do |name|
      method_name = name.gsub(/([a-z])([A-Z]{1})/) { "#{Regexp.last_match(1)}_#{Regexp.last_match(2).downcase}" }
      define_method method_name do
        self[name]
      end
    end

    def genre_information
      return unless @resource_class.respond_to?(:genre_class)
      return if self['GenreInformation'].empty?
      RWS::GenreInformation.new(self['GenreInformation'][0], @resource_class.genre_class)
    end

    def resources
      @resources ||= @resource_class.parse_response(@json)
    end

    def has_next_page?
      page && !last_page?
    end

    def last_page?
      page >= page_count
    end
  end
end
