require 'rakuten_web_service/books/resource'

module RakutenWebService
  module Books
    class Total < Books::Resource
      endpoint 'https://app.rakuten.co.jp/services/api/BooksTotal/Search/20130522'

      set_parser do |response|
        response['Items'].map do |item|
          resource_class = find_resource_by_genre_id(item['Item']['booksGenreId'])
          resource_class.new(item['Item'])
        end
      end
    end
  end
end
