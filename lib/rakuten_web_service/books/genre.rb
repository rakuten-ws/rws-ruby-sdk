require 'rakuten_web_service/genre'

module RakutenWebService
  module Books
    class Genre < RakutenWebService::BaseGenre
      set_resource_name 'books_genre'

      endpoint 'https://app.rakuten.co.jp/services/api/BooksGenre/Search/20121128'

      attribute :booksGenreId, :booksGenreName, :genreLevel

      def self.root
        new('000')
      end

      def self.new(params)
        case params
        when String
          self[params] ||= self.search(:booksGenreId => params).first
        when Hash
          super
        else
          raise ArgumentError, 'Invalid parameter for initializing Books::Genre'
        end
      end

      def children
        @params['children'] ||= RWS::Books::Genre.search(:booksGenreId => self.id).first.children
      end

      def search(params={})
        params = params.merge(:booksGenreId => self.id)
        resource = Books::Resource.find_resource_by_genre_id(self.id)
        resource.search(params)
      end

      private
      def self.repository
        @repository ||= {}
      end
    end
  end
end
