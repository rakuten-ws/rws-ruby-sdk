# frozen_string_literal: true

require 'rakuten_web_service/genre'
require 'rakuten_web_service/ichiba/ranking'
require 'rakuten_web_service/ichiba/product'

module RakutenWebService
  module Ichiba
    class Genre < RakutenWebService::BaseGenre
      endpoint 'https://openapi.rakuten.co.jp/ichibagt/api/IchibaGenre/Search/20170711'

      attribute :genreId, :genreName, :genreLevel, :englishName, :linkGenreId, :chopperFlg, :lowestFlg, :itemCount

      root_id 0

      def ranking(options = {})
        options = options.merge(genre_id: id)
        RakutenWebService::Ichiba::RankingItem.search(options)
      end

      def products(options = {})
        options = options.merge(genre_id: id)
        RakutenWebService::Ichiba::Product.search(options)
      end
    end
  end
end
