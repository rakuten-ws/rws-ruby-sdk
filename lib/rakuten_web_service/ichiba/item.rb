require 'rakuten_web_service/client'

module RakutenWebService
  module Ichiba
    class SearchResult
      include Enumerable

      def initialize(params, client)
        @params = params
        @client = client
      end

      def each
        if @results 
          @results.each do |item|
            yield item
          end
        else
          @results = []
          params = @params
          response = query
          begin
            response.body['Items'].each do |item|
              item = Item.new(item['Item'])
              yield item
              @results << item
            end
            if response.body['page'] < response.body['pageCount']
              response = query(params.merge('page' => response.body['page'] + 1))
            else 
              response = nil
            end
          end while(response) 
        end
      end

      private
      def query(params=nil)
        @client.get(params || @params)
      end
    end

    class Item 
      class << self
        def search(options)
          SearchResult.new(options, client)
        end

        private
        def endpoint
          'https://app.rakuten.co.jp/services/api/IchibaItem/Search/20130805'
        end

        def client
          @client ||= RakutenWebService::Client.new(endpoint)
        end
      end

      def initialize(params)
        @params = params
      end

      def [](key)
        camel_key = key.gsub(/([a-z]+)_(\w{1})/) { "#{$1}#{$2.capitalize}" }
        @params[key] || @params[camel_key]
      end
    end
  end
end
