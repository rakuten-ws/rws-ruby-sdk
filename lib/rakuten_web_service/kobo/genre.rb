require 'rakuten_web_service/genre'

module RakutenWebService
  module Kobo
    class Genre < RakutenWebService::BaseGenre
      set_resource_name :kobo_genre

      root_id '101'

      endpoint 'https://app.rakuten.co.jp/services/api/Kobo/GenreSearch/20131010'

      attribute :koboGenreId, :koboGenreName, :genreLevel
    end
  end
end
