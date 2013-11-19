require 'rakuten_web_service/resource'

module RakutenWebService
  module Books
    class ForeignBook < RakutenWebService::Resource
      endpoint 'https://app.rakuten.co.jp/services/api/BooksForeignBook/Search/20130522'

      set_parser do |response|
        response['Items'].map { |item| ForeignBook.new(item['Item']) }
      end

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
    end
  end
end
