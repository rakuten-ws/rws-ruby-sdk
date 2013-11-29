require 'rakuten_web_service/resource'

module RakutenWebService
  module Books
    class Resource < RakutenWebService::Resource
      set_parser do |response|
        response['Items'].map { |item| self.new(item['Item']) }
      end

      def genre
        @genre ||= Books::Genre.new(self.books_genre_id)
      end
    end
  end
end
