# frozen_string_literal: true

require 'rakuten_web_service/resource'
require 'rakuten_web_service/books/genre'

module RakutenWebService
  module Books
    class Resource < RakutenWebService::Resource
      set_parser do |response|
        response['Items'].map { |item| new(item) }
      end

      def self.find_resource_by_genre_id(genre_id)
        case genre_id
        when /^001/ then RWS::Books::Book
        when /^002/ then RWS::Books::CD
        when /^003/ then RWS::Books::DVD
        when /^004/ then RWS::Books::Software
        when /^005/ then RWS::Books::ForeignBook
        when /^006/ then RWS::Books::Game
        when /^007/ then RWS::Books::Magazine
        end
      end

      def self.genre_class
        RakutenWebService::Books::Genre
      end

      def genre
        @genre ||= books_genre_id.split('/').map do |id|
          Books::Genre.new(id)
        end
      end
      alias genres genre

      def get_attribute(name)
        name = name.to_s
        update_params unless @params[name]
        @params[name]
      end

      private

      def update_params
        item = self.class.search(update_key => self[update_key]).first
        @params = item.params
      end

      def update_key
        raise 'This method is required to be overwritten in subclasses.'
      end

      protected

      def params
        @params.dup
      end
    end
  end
end
