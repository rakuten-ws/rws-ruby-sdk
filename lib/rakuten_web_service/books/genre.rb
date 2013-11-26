require 'rakuten_web_service/resource'

module RakutenWebService
  module Books
    class Genre < Resource
      set_resource_name 'books_genre'

      endpoint 'https://app.rakuten.co.jp/services/api/BooksGenre/Search/20121128'

      set_parser do |response|
        current = response['current']
        if children = response['children']
          children = children.map { |child| Books::Genre.new(child['child']) }
          current.merge!('children' => children)
        end
        if parents = response['parents']
          parents = parents.map { |parent| Books::Genre.new(parent['parent']) }
          current.merge!('parents' => parents)
        end

        genre = Books::Genre.new(current)
        [genre]
      end

      attribute :booksGenreId, :booksGenreName, :genreLevel
    end
  end
end
