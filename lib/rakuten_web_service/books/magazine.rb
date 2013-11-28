require 'rakuten_web_service/books/resource'

module RakutenWebService
  module Books
    class Magazine < Books::Resource
      endpoint 'https://app.rakuten.co.jp/services/api/BooksMagazine/Search/20130522'

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

    end
  end
end
