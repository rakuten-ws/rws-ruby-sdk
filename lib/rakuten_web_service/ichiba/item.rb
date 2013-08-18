require 'rakuten_web_service/client'
require 'rakuten_web_service/resource'

module RakutenWebService
  module Ichiba
    class SearchResult
      include Enumerable

      def initialize(params, client)
        @params = params
        @client = client
      end

      def each
        if @results 
          @results.each do |item|
            yield item
          end
        else
          @results = []
          params = @params
          response = query
          begin
            response.body['Items'].each do |item|
              item = Item.new(item['Item'])
              yield item
              @results << item
            end
            if response.body['page'] < response.body['pageCount']
              response = query(params.merge('page' => response.body['page'] + 1))
            else 
              response = nil
            end
          end while(response) 
        end
      end

      private
      def query(params=nil)
        @client.get(params || @params)
      end
    end

    class Item < Resource
      class << self
        def search(options)
          SearchResult.new(options, client)
        end
      end
      
      endpoint 'https://app.rakuten.co.jp/services/api/IchibaItem/Search/20130805'

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
        :pointRate, :pointRateStartTime, :pointRateEndTime<
        :shopName, :shopCode, :shopUrl

    end
  end
end
