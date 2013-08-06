require 'faraday'

module RakutenWebService
  module Ichiba
    class Client
      attr_reader :url, :path

      def initialize(endpoint)
        url = URI.parse(endpoint)
        @url = "#{url.scheme}://#{url.host}"
        @path = url.path
      end

      def get(query)
        connection.get(path, query)
      end

      private
      def connection
        return @connection if @connection
        @connection = Faraday.new(:url => url) do |conn|
          conn.request :url_encoded
          conn.adapter Faraday.default_adapter
        end
      end
    end

    class Item
      class << self
        def search(options)
          client = Client.new(endpoint)
          client.get(options)
        end

        private
        def endpoint
          'https://app.rakuten.co.jp/services/api/IchibaItem/Search/20120805'
        end

        def connection
        end
      end
    end
  end
end
