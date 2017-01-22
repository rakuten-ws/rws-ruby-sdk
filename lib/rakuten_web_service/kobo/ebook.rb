require 'rakuten_web_service/resource'

module RakutenWebService
  module Kobo
    class Ebook < RakutenWebService::Resource
      endpoint 'https://app.rakuten.co.jp/services/api/Kobo/EbookSearch/20140811'

      attribute :title, :titleKana, :subTitle, :seriesName,
                :author, :authorKana, :publisherName,
                :itemNumber, :itemCaption,
                :salesDate, :itemPrice,
                :itemUrl, :affiliateUrl,
                :smallImageUrl, :mediumImageUrl, :largeImageUrl,
                :reviewCount, :reviewAverage,
                :koboGenreId

      set_parser do |response|
        response['Items'].map { |i| new(i['Item']) }
      end

      def self.genre_class
        RakutenWebService::Kobo::Genre
      end

      def genre
        Kobo::Genre.new(kobo_genre_id)
      end
    end
  end
end
