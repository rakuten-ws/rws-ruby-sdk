require 'rakuten_web_service/client'

module RakutenWebService
  module Ichiba
    class Genre
      class SearchResult

      end

      class << self
        def search(params)
          client.get(params).body['current']
        end

        private
        def endpoint
          'https://app.rakuten.co.jp/services/api/IchibaGenre/Search/20120723'
        end

        def client
          @client ||= RakutenWebService::Client.new(endpoint)
        end
      end
    end
  end
end
