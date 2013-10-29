require 'rakuten_web_service/resource'

module RakutenWebService
  module Books
    class DVD < RakutenWebService::Resource
      endpoint 'https://app.rakuten.co.jp/services/api/BooksDVD/Search/20130522'

      set_parser do |response|
        response['Items'].map { |item| DVD.new(item['Item']) }
      end

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
    end
  end
end
