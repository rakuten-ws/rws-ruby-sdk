module RakutenWebService
  module Ichiba
    class Genre < Resource
      @@repository = {}

      class << self
        def parse_response(response)
          [Genre.new(response['current'])]
        end

        def new(params)
          case params
          when Integer, String
            Genre[params.to_s] || search(:genre_id => params.to_s).first
          when Hash
            super
          end
        end

        def root
          self.new(0)
        end

        def [](id)
          @@repository[id.to_s]
        end

        def []=(id, genre)
          @@repository[id.to_s] = genre
        end
      end

      endpoint 'https://app.rakuten.co.jp/services/api/IchibaGenre/Search/20120723'
      attribute :genreId, :genreName, :genreLevel

      def initialize(params)
        super
        Genre[self.id.to_s] = self
      end
    end
  end
end
