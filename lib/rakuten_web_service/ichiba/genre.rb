require 'rakuten_web_service/client'
require 'rakuten_web_service/resource'

module RakutenWebService
  module Ichiba
    class Genre < Resource
      @@repository = {}

      class << self
        def new(params)
          case params
          when Integer, String
            Genre[params.to_s] || search(:genre_id => params.to_s).first
          when Hash
            super
          end
        end

        def [](id)
          @@repository[id]
        end

        def []=(id, genre)
          @@repository[id] = genre
        end
      end

      endpoint 'https://app.rakuten.co.jp/services/api/IchibaGenre/Search/20120723'
      attribute :genreId, :genreName, :genreLevel

      def initialize(params)
        super
        Genre[self.id.to_s] = self
      end

      def self.parse_response(response)
        [Genre.new(response['current'])]
      end
    end
  end
end
