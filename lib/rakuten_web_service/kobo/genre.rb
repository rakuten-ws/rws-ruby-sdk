# frozen_string_literal: true

require 'rakuten_web_service/genre'

module RakutenWebService
  module Kobo
    class Genre < RakutenWebService::BaseGenre
      self.resource_name = :kobo_genre

      root_id '101'

      endpoint 'https://app.rakuten.co.jp/services/api/Kobo/GenreSearch/20131010'

      attribute :koboGenreId, :koboGenreName, :genreLevel, :itemCount

      def search(options = {})
        options = options.merge(self.class.genre_id_key => id)
        RWS::Kobo::Ebook.search(options)
      end
    end
  end
end
