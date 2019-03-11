# frozen_string_literal: true

require 'rakuten_web_service/all_proxy'
require 'rakuten_web_service/genre_information'
require 'rakuten_web_service/string_support'

module RakutenWebService
  class SearchResult
    include Enumerable

    using RakutenWebService::StringSupport

    def initialize(params, resource_class)
      @params = params.dup
      @resource_class = resource_class
      @client = RakutenWebService::Client.new(resource_class)
    end

    def search(params)
      self.class.new(self.params.dup.merge!(params), @resource_class)
    end
    alias with search

    def each
      response.each do |resource|
        yield resource
      end
    end

    def all(&block)
      proxy = AllProxy.new(self)
      proxy.each(&block) if block
      proxy
    end

    def params
      @params ||= {}
    end

    def params_to_get_next_page
      @params.merge('page' => @response.body['page'] + 1)
    end

    def order(options)
      new_params = params.dup
      if options.is_a? Hash
        key, sort_order = *options.to_a.last
        key = key.to_s.to_camel
        new_params[:sort] = case sort_order.to_s.downcase
                            when 'desc'
                              "-#{key}"
                            when 'asc'
                              "+#{key}"
                            end
      elsif options.to_s == 'standard'
        new_params[:sort] = 'standard'
      else
        raise ArgumentError, "Invalid Sort Option: #{options.inspect}"
      end
      self.class.new(new_params, @resource_class)
    end

    def query
      ensure_retries { @client.get(params) }
    end
    alias fetch_result query

    def response
      @response ||= query
    end

    def has_next_page?
      response.has_next_page?
    end

    def next_page
      search(page: response.page + 1)
    end

    def has_previous_page?
      response.has_previous_page?
    end

    def previous_page
      search(page: response.page - 1)
    end

    def page(num)
      search(page: num)
    end

    def genre_information
      response.genre_information
    end

    private

    def ensure_retries(max_retries = RakutenWebService.configuration.max_retries)
      yield
    rescue RWS::TooManyRequests => e
      raise e if max_retries <= 0
      max_retries -= 1
      sleep 1
      retry
    end
  end
end
