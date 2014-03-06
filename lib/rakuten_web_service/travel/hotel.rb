require 'rakuten_web_service/resource'

module RakutenWebService
  module Travel
    class Hotel < RakutenWebService::Travel::Resource
      endpoint 'https://app.rakuten.co.jp/services/api/Travel/SimpleHotelSearch/20131024'

      set_parser do |response|
        response['hotels'].map do |hotel_info|
          Hotel.new(hotel_info)
        end
      end

      def initialize(params)
        @params = {}
        @params['hotelBasicInfo'] = params['hotel'][0]['hotelBasicInfo']
        @params['hotelRatingInfo'] = params['hotel'][1]['hotelRatingInfo']
      end

      attribute :hotelBasicInfo, :hotelRatingInfo
    end
  end
end
