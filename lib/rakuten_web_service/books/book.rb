require 'rakuten_web_service/resource'

module RakutenWebService
  module Books
    class Book < RakutenWebService::Resource
      endpoint 'https://app.rakuten.co.jp/services/api/BooksBook/Search/20130522'

      set_parser do |response|
        response['Items'].map { |item| Book.new(item['Item']) }
      end

      attribute :title, :titleKana, :subTitle, :subTitleKana,
                :seriesName, :seriesNameKana,
                :contents, :contentsKana,
                :author, :authorKana, :publisherName,
                :size, :isbn,
                :itemCaption, :itemPrice, :listPrice,
                :discountRate, :discountPrice,
                :salesDate,
                :itemUrl, :affiliateUrl,
                :smallImageUrl, :mediumImageUrl, :largeImageUrl,
                :chirayomiUrl,
                :availability,
                :postageFlag, :limitedFlag,
                :reviewCount, :reviewAverage,
                :booksGenreId
    end
  end
end
