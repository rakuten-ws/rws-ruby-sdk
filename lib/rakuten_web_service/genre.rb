require 'rakuten_web_service/resource'

module RakutenWebService
  class BaseGenre < RakutenWebService::Resource
    def self.inherited(klass)
      klass.set_parser do |response|
        current = response['current']
        if children = response['children']
          children = children.map { |child| klass.new(child['child']) }
          current['children'] = children
        end
        if parents = response['parents']
          parents = parents.map { |parent| klass.new(parent['parent']) }
          current['parents'] = parents
        end

        genre = klass.new(current)
        [genre]
      end
    end

    def self.new(params)
      case params
      when Integer, String
        if cache = repository[params.to_s]
          new(cache)
        else
          search(genre_id_key => params.to_s).first
        end
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
      self.class[id.to_s] = @params.reject { |k, _v| k == 'itemCount' }
    end

    def children
      @params['children'] ||= self.class.search(self.class.genre_id_key => id).first.children
    end

    def parents
      @params['parents'] ||= self.class.search(self.class.genre_id_key => id).first.parents
    end
  end
end
