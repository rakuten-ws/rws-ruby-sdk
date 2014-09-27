require 'rakuten_web_service/genre'

module RakutenWebService
  module Books
    class Genre < RakutenWebService::BaseGenre
      set_resource_name 'books_genre'

      endpoint 'https://app.rakuten.co.jp/services/api/BooksGenre/Search/20121128'

      attribute :booksGenreId, :booksGenreName, :genreLevel

      root_id '000'

      def search(params={})
        params = params.merge(:booksGenreId => self.id)
        resource = Books::Resource.find_resource_by_genre_id(self.id)
        resource.search(params)
      end
    end
  end
end
