require 'rakuten_web_service/resource'

module RakutenWebService
  class BaseGenre < RakutenWebService::Resource
    def self.inherited(klass)
      klass.set_parser do |response|
        current = response['current']
        if children = response['children']
          children = children.map { |child| klass.new(child['child']) }
          current.merge!('children' => children)
        end
        if parents = response['parents']
          parents = parents.map { |parent| klass.new(parent['parent']) }
          current.merge!('parents' => parents)
        end

        genre = klass.new(current)
        [genre]
      end
    end

    def self.new(params)
      case params
      when Integer, String
        repository[params.to_s] || search(genre_id_key => params.to_s).first
      when Hash
        super
      end
    end

    def self.genre_id_key
      :"#{resource_name}_id"
    end

    def self.root_id(id=nil)
      @root_id = id || @root_id
    end

    def self.root
      self.new(root_id)
    end

    def self.[](id)
      repository[id.to_s] || new(id)
    end

    def self.[]=(id, genre)
      repository[id.to_s] = genre
    end

    def self.repository
      @repository ||= {}
    end

    def initialize(params)
      super
      self.class[self.id.to_s] = self
    end

    def children
      @params['children'] ||= self.class.search(self.class.genre_id_key => self.id).first.children
    end
  end
end
