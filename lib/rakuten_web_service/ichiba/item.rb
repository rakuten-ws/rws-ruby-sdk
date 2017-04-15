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

      endpoint 'https://app.rakuten.co.jp/services/api/IchibaItem/Search/20140222'

      set_parser do |response|
        response['Items'].map { |item| Item.new(item) }
      end

      attribute :itemName, :catchcopy, :itemCode, :itemPrice,
        :itemCaption, :itemUrl, :affiliateUrl, :imageFlag,
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
        :genreId

      def genre
        Genre.new(self.genre_id)
      end

      def shop
        Shop.new({
          'shopName' => self.shop_name,
          'shopCode' => self.shop_code,
          'shopUrl' => self.shop_url,
          'shopAffiliateUrl' => self.shop_affiliate_url
        })
      end
    end
  end
end
