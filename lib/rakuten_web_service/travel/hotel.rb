# frozen_string_literal: true

require 'rakuten_web_service/travel/resource'

module RakutenWebService
  module Travel
    class Hotel < RakutenWebService::Travel::Resource
      endpoint 'https://app.rakuten.co.jp/services/api/Travel/SimpleHotelSearch/20170426'

      parser do |response|
        response['hotels'].map do |hotel_info|
          Hotel.new(hotel_info)
        end
      end

      def initialize(params)
        @params = {}
        self.class.attribute_names.each_with_index do |key, i|
          @params[key] = params[i][key] if params[i]
        end
      end

      def self.attribute_names
        %w(hotelBasicInfo hotelRatingInfo hotelDetailInfo hotelFacilitiesInfo hotelPolicyInfo hotelOtherInfo)
      end

      attribute *attribute_names
    end
  end
end
