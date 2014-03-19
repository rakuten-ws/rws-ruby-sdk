require 'rakuten_web_service/resource'

module RakutenWebService
  module Ichiba
    class Product < Resource
      endpoint 'https://app.rakuten.co.jp/services/api/Product/Search/20140305'

      set_parser do |response|
        (response['Products'] || []).map { |prod| Product.new(prod) }
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
        :genreId, :genreName
    end
  end
end
