require 'rakuten_web_service/resource'
require 'rakuten_web_service/ichiba/genre'

module RakutenWebService
  module Ichiba
    class Product < Resource
      endpoint 'https://app.rakuten.co.jp/services/api/Product/Search/20140305'

      set_parser do |response|
        (response['Products'] || []).map { |prod| Product.new(prod['Product']) }
      end

      attribute :productId, :productName, :productNo, :brandName,
        :productUrlPC, :productUrlMobile, :affiliateUrl,
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
        :rankTargetGenreId, :rankTargetProductCount,
        :genreId, :genreName,
        :ProductDetails

      def genre
        RakutenWebService::Ichiba::Genre.new(self.genre_id)
      end
    end
  end
end
