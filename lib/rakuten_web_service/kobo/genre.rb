require 'rakuten_web_service/resource'

module RakutenWebService
  module Kobo
    class Genre < RakutenWebService::Resource
      endpoint 'https://app.rakuten.co.jp/services/api/Kobo/GenreSearch/20131010'

      set_parser do |response|
        current = response['current']
        if children = response['children']
          children = children.map { |child| Kobo::Genre.new(child['child']) }
          current.merge!('children' => children)
        end
        if parents = response['parents']
          parents = parents.map { |parent| Kobo::Genre.new(parent['parent']) }
          current.merge!('parents' => parents)
        end

        genre = Kobo::Genre.new(current)
        [genre]
      end
    end
  end
end
