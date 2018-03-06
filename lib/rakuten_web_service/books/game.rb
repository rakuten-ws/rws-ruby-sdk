# frozen_string_literal: true

require 'rakuten_web_service/books/resource'

module RakutenWebService
  module Books
    class Game < Books::Resource
      endpoint 'https://app.rakuten.co.jp/services/api/BooksGame/Search/20170404'

      attribute :title, :titleKana, :hardware, :jan, :makerCode,
                :itemCaption,
                :salesDate,
                :itemPrice, :listPrice, :discountRate, :discountPrice,
                :itemUrl, :affiliateUrl,
                :contents, :contentsKana,
                :smallImageUrl, :mediumImageUrl, :largeImageUrl,
                :availability,
                :postageFlag, :limitedFlag,
                :reviewCount, :reviewAverage,
                :booksGenreId

      def update_key
        'jan'
      end
    end
  end
end
