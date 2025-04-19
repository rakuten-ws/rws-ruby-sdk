# frozen_string_literal: true

require 'rakuten_web_service/resource'

module RakutenWebService
  module Ichiba
    class Item < Resource
      class << self
        def ranking(options={})
          RakutenWebService::Ichiba::RankingItem.search(options)
        end

        def genre_class
          RakutenWebService::Ichiba::Genre
        end
      end

      endpoint 'https://app.rakuten.co.jp/services/api/IchibaItem/Search/20220601'

      parser do |response|
        (response['Items'] || []).map { |item| Item.new(item) }
      end

      attribute :itemName, :catchcopy, :itemCode, :itemPrice,
                :itemCaption, :itemUrl, :affiliateUrl, :imageFlag,
                :itemPriceBaseField,
                :itemPriceMax1, :itemPriceMax2, :itemPriceMax3,
                :itemPriceMin1, :itemPriceMin2, :itemPriceMin3,
                :smallImageUrls, :mediumImageUrls,
                :availability, :taxFlag,
                :postageFlag, :creditCardFlag,
                :shopOfTheYearFlag,
                :shipOverseasFlag, :shipOverseasArea,
                :asurakuFlag, :asurakuClosingTime, :asurakuArea,
                :affiliateRate,
                :startTime, :endTime,
                :reviewCount, :reviewAverage,
                :pointRate, :pointRateStartTime, :pointRateEndTime,
                :shopName, :shopCode, :shopUrl, :shopAffiliateUrl,
                :genreId, :tagIds

      def genre
        Genre.new(genre_id)
      end

      def shop
        Shop.new(
          'shopName' => shop_name,
          'shopCode' => shop_code,
          'shopUrl' => shop_url,
          'shopAffiliateUrl' => shop_affiliate_url
        )
      end
    end
  end
end
