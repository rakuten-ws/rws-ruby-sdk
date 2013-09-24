require 'rakuten_web_service/ichiba/item'

module RakutenWebService
  module Ichiba
    class RankingItem < RakutenWebService::Ichiba::Item
      endpoint 'https://app.rakuten.co.jp/services/api/IchibaItem/Ranking/20120927'

      set_parser do |response|
        response['Items'].map { |item| RankingItem.new(item['Item']) }
      end

      attribute :rank
    end
  end
end
