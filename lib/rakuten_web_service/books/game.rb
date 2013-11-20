require 'rakuten_web_service/resource'

module RakutenWebService
  module Books
    class Game < Resource
      endpoint 'https://app.rakuten.co.jp/services/api/BooksGame/Search/20130522'

      set_parser do |response|
        response['Items'].map { |item| Game.new(item['Item']) }
      end

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

    end
  end
end
