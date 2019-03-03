# frozen_string_literal: true

require 'rakuten_web_service/resource'

module RakutenWebService
  class BaseGenre < RakutenWebService::Resource
    def self.inherited(klass)
      super

      klass.set_parser do |response|
        current = response['current']
        %w[children parents brothers].each do |type|
          elements = Array(response[type]).map { |e| klass.new(e) }
          current.merge!(type => elements)
        end
        genre = klass.new(current)
        [genre]
      end
    end

    def self.new(params)
      case params
      when Integer, String
        return new(repository[params.to_s]) unless repository[params.to_s].nil?
        search(genre_id_key => params.to_s).first
      when Hash
        super
      end
    end

    def self.genre_id_key
      :"#{resource_name}_id"
    end

    def self.root_id(id = nil)
      @root_id = id || @root_id
    end

    def self.root
      new(root_id)
    end

    def self.[](id)
      new(repository[id.to_s] || id)
    end

    def self.[]=(id, genre)
      repository[id.to_s] = genre
    end

    def self.repository
      @repository ||= {}
    end

    def initialize(params)
      super
      self.class[id.to_s] = @params.reject { |k, _| k == 'itemCount' }
    end

    def children
      @params['children'] ||= self.class.search(self.class.genre_id_key => id).first.children
    end

    def brothers
      @params['brothers'] ||= self.class.search(self.class.genre_id_key => id).first.brothers
    end

    def parents
      @params['parents'] ||= self.class.search(self.class.genre_id_key => id).first.parents
    end
  end
end
