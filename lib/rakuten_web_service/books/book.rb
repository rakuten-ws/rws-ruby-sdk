# frozen_string_literal: true

require 'rakuten_web_service/books/resource'

module RakutenWebService
  module Books
    class Book < Books::Resource
      endpoint 'https://app.rakuten.co.jp/services/api/BooksBook/Search/20170404'

      attribute :title, :titleKana, :subTitle, :subTitleKana,
                :seriesName, :seriesNameKana,
                :contents, :contentsKana,
                :author, :authorKana, :publisherName,
                :size, :isbn,
                :itemCaption, :itemPrice, :listPrice,
                :discountRate, :discountPrice,
                :salesDate,
                :itemUrl, :affiliateUrl,
                :smallImageUrl, :mediumImageUrl, :largeImageUrl,
                :chirayomiUrl,
                :availability,
                :postageFlag, :limitedFlag,
                :reviewCount, :reviewAverage,
                :booksGenreId

      def update_key
        'isbn'
      end
    end
  end
end
