# encoding: utf-8

require 'rakuten_web_service/resource'

module RakutenWebService
  module Kobo
    class Ebook < RakutenWebService::Resource
      endpoint 'https://app.rakuten.co.jp/services/api/Kobo/EbookSearch/20131010'

      attribute :title, :titleKana, :subTitle,
        :author, :authorKana, :publisherName,
        :itemNumber, :itemCaption,
        :salesDate, :itemPrice,
        :itemUrl, :affiliateUrl,
        :smallImageUrl, :mediumImageUrl, :largeImageUrl,
        :reviewCount, :reviewAverage,
        :koboGenreId

      set_parser do |response|
        response['Items'].map { |i| self.new(i['Item']) }
      end

      def genre
        Kobo::Genre.new(self.kobo_genre_id)
      end
    end
  end
end
