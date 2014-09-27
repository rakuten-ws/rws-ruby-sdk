require 'rakuten_web_service/genre'
require 'rakuten_web_service/ichiba/ranking'
require 'rakuten_web_service/ichiba/product'

module RakutenWebService
  module Ichiba
    class Genre < RakutenWebService::BaseGenre
      endpoint 'https://app.rakuten.co.jp/services/api/IchibaGenre/Search/20120723'

      attribute :genreId, :genreName, :genreLevel

      root_id 0

      def ranking(options={})
        RakutenWebService::Ichiba::RankingItem.search(:genre_id => self.id)
      end

      def products(options={})
        options = options.merge(:genre_id => self.id)
        RakutenWebService::Ichiba::Product.search(options)
      end
    end
  end
end
