require 'rakuten_web_service/ichiba/item'

module RakutenWebService
  module Ichiba
    class RankingItem < RakutenWebService::Ichiba::Item
      endpoint 'https://app.rakuten.co.jp/services/api/IchibaItem/Ranking/20120927'
      attribute :rank

      def self.parse_response(response)
        response['Items'].map { |item| RankingItem.new(item['Item']) }
      end
    end
  end
end
