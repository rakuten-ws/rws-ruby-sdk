require 'rakuten_web_service/client'

module RakutenWebService
  module Ichiba
    class Item 
      class << self
        def search(options)
          response = client.get(options)
          response.body['Items'].map do |item|
            Item.new(item['Item'])
          end
        end

        private
        def endpoint
          'https://app.rakuten.co.jp/services/api/IchibaItem/Search/20120805'
        end

        def client
          @client ||= RakutenWebService::Client.new(endpoint)
        end

        protected :new
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
