# frozen_string_literal: true

require 'rakuten_web_service/genre'

module RakutenWebService
  module Books
    class Genre < RakutenWebService::BaseGenre
      self.resource_name = 'books_genre'

      endpoint 'https://app.rakuten.co.jp/services/api/BooksGenre/Search/20121128'

      attribute :booksGenreId, :booksGenreName, :genreLevel, :itemCount

      root_id '000'

      def search(params = {})
        params = params.merge(booksGenreId: id)
        resource = Books::Resource.find_resource_by_genre_id(id)
        resource.search(params)
      end
    end
  end
end
