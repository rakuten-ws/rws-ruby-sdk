# frozen_string_literal: true

require 'rakuten_web_service/resource'
require 'rakuten_web_service/ichiba/genre'

module RakutenWebService
  module Ichiba
    class Product < Resource
      endpoint 'https://openapi.rakuten.co.jp/ichibaproduct/api/Product/Search/20250801'

      parser do |response|
        (response['Products'] || []).map { |prod| Product.new(prod) }
      end

      attribute :productId, :productCode, :productName, :productNo, :brandName,
        :productUrlPC, :productUrlMobile, :searchUrl, :affiliateUrl,
        :smallImageUrl, :mediumImageUrl,
        :productCaption, :releaseDate,
        :makerCode, :makerName, :makerNameKana, :makerNameFormal,
        :makerPageUrlPC, :makerPageUrlMobile,
        :itemCount, :salesItemCount,
        :usedExcludeCount, :usedExcludeSalesItemCount,
        :maxPrice, :salesMaxPrice, :usedExcludeMaxPrice, :usedExcludeSalesMaxPrice,
        :minPrice, :salesMinPrice, :usedExcludeMinPrice, :usedExcludeSalesMinPrice,
        :averagePrice,
        :reviewCount, :reviewAverage, :reviewUrlPC, :reviewUrlMobile,
        :rank, :rankTargetGenreId, :rankTargetProductCount,
        :genreId, :genreName,
        :ProductDetails

      def genre
        RakutenWebService::Ichiba::Genre.new(genre_id)
      end
    end
  end
end
