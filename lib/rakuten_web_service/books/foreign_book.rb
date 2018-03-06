# frozen_string_literal: true

require 'rakuten_web_service/resource'

module RakutenWebService
  module Books
    class ForeignBook < Books::Resource
      endpoint 'https://app.rakuten.co.jp/services/api/BooksForeignBook/Search/20170404'

      attribute :title, :titleKana, :japaneseTitle,
                :author, :authorKana,
                :publishName, :isbn, :itemCaption, :salesDate,
                :itemPrice, :listPrice,
                :discountRate, :discountPrice,
                :itemUrl, :affiliateUrl,
                :smallImageUrl, :mediumImageUrl, :largeImageUrl,
                :availability, :postageFlag, :limitedFlag,
                :reviewCount, :reviewAverage,
                :booksGenreId

      def update_key
        'isbn'
      end
    end
  end
end
