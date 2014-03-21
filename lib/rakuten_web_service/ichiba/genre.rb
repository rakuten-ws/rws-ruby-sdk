require 'rakuten_web_service/resource'
require 'rakuten_web_service/ichiba/ranking'
require 'rakuten_web_service/ichiba/product'

module RakutenWebService
  module Ichiba
    class Genre < Resource

      class << self
        def new(params)
          case params
          when Integer, String
            Genre[params.to_s] || search(:genre_id => params.to_s).first
          when Hash
            super
          end
        end

        def root
          self.new(0)
        end

        def [](id)
          repository[id.to_s]
        end

        def []=(id, genre)
          repository[id.to_s] = genre
        end

        private
        def repository
          @repository ||= {}
        end
      end

      endpoint 'https://app.rakuten.co.jp/services/api/IchibaGenre/Search/20120723'

      set_parser do |response|
        current = response['current']
        if children = response['children']
          children = children.map { |child| Genre.new(child['child']) }
          current.merge!('children' => children)
        end
        if parents = response['parents']
          parents = parents.map { |parent| Genre.new(parent['parent']) }
          current.merge!('parents' => parents)
        end

        genre = Genre.new(current)
        [genre]
      end

      attribute :genreId, :genreName, :genreLevel

      def initialize(params)
        super
        Genre[self.id.to_s] = self
      end

      def ranking(options={})
        RakutenWebService::Ichiba::RankingItem.search(:genre_id => self.id)
      end

      def products(options={})
        options = options.merge(:genre_id => self.id)
        RakutenWebService::Ichiba::Product.search(options)
      end

      def children
        @params['children'] ||= Genre.search(:genre_id => self.id).first.children
      end
    end
  end
end
