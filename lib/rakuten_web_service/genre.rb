require 'rakuten_web_service/resource'

module RakutenWebService
  class BaseGenre < RakutenWebService::Resource
    def self.inherited(klass)
      klass.set_parser do |response|
        current = response['current']
        children = Array(response['children']).map { |child| klass.new(child) }
        current.merge!('children' => children)
        parents = Array(response['parents']).map { |parent| klass.new(parent) }
        current.merge!('parents' => parents)
        brothers = Array(response['brothers']).map { |brother| klass.new(brother) }
        current.merge!('brothers' => brothers)

        genre = klass.new(current)
        [genre]
      end
    end

    def self.new(params)
      case params
      when Integer, String
        unless repository[params.to_s].nil?
          self.new(repository[params.to_s])
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

    def self.root_id(id=nil)
      @root_id = id || @root_id
    end

    def self.root
      self.new(root_id)
    end

    def self.[](id)
      self.new(repository[id.to_s] || id)
    end

    def self.[]=(id, genre)
      repository[id.to_s] = genre
    end

    def self.repository
      @repository ||= {}
    end

    def initialize(params)
      super
      self.class[self.id.to_s] = @params.reject { |k, _| k == 'itemCount' }
    end

    def children
      @params['children'] ||= self.class.search(self.class.genre_id_key => self.id).first.children
    end

    def brothers
      @params['brothers'] ||= self.class.search(self.class.genre_id_key => self.id).first.brothers
    end

    def parents
      @params['parents'] ||= self.class.search(self.class.genre_id_key => self.id).first.parents
    end
  end
end
