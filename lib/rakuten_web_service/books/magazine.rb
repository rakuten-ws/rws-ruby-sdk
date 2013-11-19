require 'rakuten_web_service/resource'

module RakutenWebService
  module Books
    class Magazine < Resource
      endpoint 'https://app.rakuten.co.jp/services/api/BooksMagazine/Search/20130522'

      set_parser do |response|
        response['Items'].map { |item| Magazine.new(item['Item']) }
      end

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
                :reviewCount, :reviwAverage,
                :booksGenreId

    end
  end
end
