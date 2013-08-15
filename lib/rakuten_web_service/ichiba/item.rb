require 'rakuten_web_service/client'

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

    class Item 
      class << self
        def search(options)
          SearchResult.new(options, client)
        end

        def attributes
          %w[
            itemName catchcopy itemCode itemPrice
            itemCaption itemUrl affiliateUrl imageFlag
            smallImageUrls mediumImageUrls
            availability taxFlag 
            postageFlag creditCardFlag
            shopOfTheYearFlag
            shipOverseasFlag shipOverseasArea
            asurakuFlag asurakuClosingTime asurakuArea
            affiliateRate
            startTime endTime
            reviewCount reviewAverage
            pointRate pointRateStartTime pointRateEndTime
            shopName shopCode shopUrl
          ]
        end

        private
        def endpoint
          'https://app.rakuten.co.jp/services/api/IchibaItem/Search/20130805'
        end

        def client
          @client ||= RakutenWebService::Client.new(endpoint)
        end
      end

      attributes.each do |attribute|
        method_name = attribute.gsub(/([a-z]+)([A-Z]{1})/) do
          "#{$1}_#{$2.downcase}"
        end
        method_name = method_name.sub(/^item_(\w+)$/) { $1 }
        self.class_eval <<-CODE
          def #{method_name}
            @params['#{attribute.to_s}']
          end
        CODE
      end

      def initialize(params)
        @params = params
      end

      def [](key)
        camel_key = key.gsub(/([a-z]+)_(\w{1})/) { "#{$1}#{$2.capitalize}" }
        @params[key] || @params[camel_key]
      end
    end
  end
end
