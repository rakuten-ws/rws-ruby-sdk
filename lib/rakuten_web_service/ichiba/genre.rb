require 'rakuten_web_service/client'
require 'rakuten_web_service/resource'

module RakutenWebService
  module Ichiba
    class Genre < Resource
      attribute :genreId, :genreName, :genreLevel

      class SearchResult

      end

      class << self
        def search(params)
          Genre.new(client.get(params).body['current'])
        end

        private
        def endpoint
          'https://app.rakuten.co.jp/services/api/IchibaGenre/Search/20120723'
        end
      end
    end
  end
end
