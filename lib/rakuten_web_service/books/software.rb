require 'rakuten_web_service/resource'

module RakutenWebService
  module Books
    class Software < Resource
      endpoint 'https://app.rakuten.co.jp/services/api/BooksSoftware/Search/20130522'

      set_parser do |response|
        response['Items'].map { |item| Software.new(item['Item']) }
      end

      attribute :title, :titleKana, :os, :jan, :makerCode,
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
