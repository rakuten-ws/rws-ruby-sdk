require 'rakuten_web_service/resource'

module RakutenWebService
  module Books
    class CD < RakutenWebService::Resource
      endpoint 'https://app.rakuten.co.jp/services/api/BooksCD/Search/20130522'

      set_parser do |response|
        response['Items'].map { |item| CD.new(item['Item']) }
      end

      attribute :title, :titleKana, :artistName, :artistNameKana,
                :label, :jan, :makerCode,
                :itemCaption, :playList, :salesDate,
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
