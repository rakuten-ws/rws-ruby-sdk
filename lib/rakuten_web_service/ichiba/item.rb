require 'rakuten_web_service/client'

module RakutenWebService
  module Ichiba
    class SearchResult
      include Enumerable

      def initialize(params, client)
        @params = params
        @client = client
      end

      def each(&block)
        return @results if @results

        @results = []
        params = @params
        response = query
        begin
          response.body['Items'].each do |item|
            @results << Item.new(item['Item'])
          end
          if response.body['page'] < response.body['pageCount']
            response = query(params.merge('page' => response.body['page'] + 1))
          else 
            response = nil
          end
        end while(response) 
        @results
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
          'https://app.rakuten.co.jp/services/api/IchibaItem/Search/20120805'
        end

        def client
          @client ||= RakutenWebService::Client.new(endpoint)
        end
      end

      def initialize(params)
        @params = params
      end

      def [](key)
        @params[key]
      end
    end
  end
end
