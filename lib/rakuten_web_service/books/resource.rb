require 'rakuten_web_service/resource'

module RakutenWebService
  module Books
    class Resource < RakutenWebService::Resource
      set_parser do |response|
        response['Items'].map { |item| self.new(item['Item']) }
      end

      def self.find_resource_by_genre_id(genre_id)
        case genre_id
        when /^001/ then RWS::Books::Book
        when /^002/ then RWS::Books::CD
        when /^003/ then RWS::Books::DVD
        when /^004/ then RWS::Books::Software
        when /^005/ then RWS::Books::ForeignBook
        when /^006/ then RWS::Books::Game
        when /^007/ then RWS::Books::Magazine
        end
      end

      def genre
        @genre ||= Books::Genre.new(self.books_genre_id)
      end
    end
  end
end
