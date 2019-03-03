# frozen_string_literal: true

require 'rakuten_web_service/books/resource'

module RakutenWebService
  module Books
    class DVD < Books::Resource
      endpoint 'https://app.rakuten.co.jp/services/api/BooksDVD/Search/20170404'

      attribute :title, :titleKana, :artistName, :artistNameKana,
                :label, :jan, :makerCode,
                :itemCaption, :salesDate,
                :itemPrice, :listPrice,
                :discountRate, :discountPrice,
                :itemUrl, :affiliateUrl,
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
