# frozen_string_literal: true

require 'rakuten_web_service/string_support'

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

    using RakutenWebService::StringSupport

    %w[count hits page first last carrier pageCount].each do |name|
      method_name = name.to_snake
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

    def next_page?
      page && !last_page?
    end

    def previous_page?
      page && !first_page?
    end

    def first_page?
      page == 1
    end

    def last_page?
      page >= page_count
    end
  end
end
