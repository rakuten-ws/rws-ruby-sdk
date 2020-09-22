# frozen_string_literal: true

require 'rakuten_web_service/resource'

module RakutenWebService
  module Kobo
    class Ebook < RakutenWebService::Resource
      endpoint 'https://app.rakuten.co.jp/services/api/Kobo/EbookSearch/20170426'

      attribute :title, :titleKana, :subTitle, :seriesName,
        :author, :authorKana, :publisherName,
        :itemNumber, :itemCaption,
        :salesDate, :itemPrice,
        :itemUrl, :affiliateUrl,
        :smallImageUrl, :mediumImageUrl, :largeImageUrl,
        :reviewCount, :reviewAverage,
        :koboGenreId

      parser do |response|
        response['Items'].map { |i| new(i) }
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
