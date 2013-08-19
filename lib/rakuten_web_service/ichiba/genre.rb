require 'rakuten_web_service/client'
require 'rakuten_web_service/resource'

module RakutenWebService
  module Ichiba
    class Genre < Resource
      endpoint 'https://app.rakuten.co.jp/services/api/IchibaGenre/Search/20120723'
      attribute :genreId, :genreName, :genreLevel

      def self.parse_response(response)
        [Genre.new(response['current'])]
      end
    end
  end
end
