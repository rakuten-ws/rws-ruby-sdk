# frozen_string_literal: true

require 'rakuten_web_service/books/resource'

module RakutenWebService
  module Books
    class Magazine < Books::Resource
      endpoint 'https://app.rakuten.co.jp/services/api/BooksMagazine/Search/20170404'

      attribute :title, :titleKana, :publisherName, :jan,
                :itemCaption,
                :salesDate, :cycle,
                :itemPrice, :listPrice, :discountRate, :discountPrice,
                :itemUrl, :affiliateUrl,
                :contents, :contentsKana,
                :smallImageUrl, :mediumImageUrl, :largeImageUrl,
                :chirayomiUrl,
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
