require 'rakuten_web_service/travel/resource'

module RakutenWebService
  module Travel
    module AreaClass
      def search(options = {})
        Base.search(options)
      end

      def [](class_code)
        LargeClass[class_code] or
          MiddleClass[class_code] or
          SmallClass[class_code] or
          DetailClass[class_code]
      end
      module_function :search, :[]

      class Base < RakutenWebService::Travel::Resource
        endpoint 'https://app.rakuten.co.jp/services/api/Travel/GetAreaClass/20131024'

        set_parser do |response|
          response['areaClasses']['largeClasses'].map do |data|
            LargeClass.new(data)
          end
        end

        class << self
          def area_classes
            @@area_classes ||= {}
          end

          def inherited(klass)
            class_name = klass.to_s.split('::').last
            area_level = class_name.to_s[/\A(\w*)Class\Z/, 1].downcase
            class << klass
              attr_reader :area_level
            end
            klass.instance_variable_set(:@area_level, area_level)

            area_classes[klass.area_level] = klass

            klass.attribute :"#{area_level}ClassCode", :"#{area_level}ClassName"
          end

          def [](area_code)
            AreaClass.search.first unless repository[area_level][area_code]
            repository[area_level][area_code]
          end

          def new(*args)
            obj = super
            repository[area_level][obj.class_code] = obj
            obj
          end

          def repository
            @@repository ||= Hash.new { |h, k| h[k] = {} }
          end
        end

        attr_reader :parent, :children

        def initialize(data, parent = nil)
          @parent = parent
          class_data = data
          @params, @children = *(case class_data
                                 when Array
                                   class_data.first(2)
                                 when Hash
                                   [class_data, nil]
                                 end)

          if !children.nil? && !children.empty?
            children_class = children.keys.first[/\A(\w*)Classes\Z/, 1]
            class_name = "#{children_class}Classes"
            @params[class_name] = children[class_name].map do |child_data|
              Base.area_classes[children_class].new(child_data["#{children_class}Class"], self)
            end
            @children = @params[class_name]
          else
            @children = []
          end
        end

        def area_level
          self.class.area_level
        end

        def class_code
          self["#{area_level}ClassCode"]
        end

        def class_name
          self["#{area_level}ClassName"]
        end

        def to_query
          query = { "#{area_level}ClassCode" => class_code }
          query = query.merge(parent.to_query) unless parent.nil?
          query
        end

        def search(params = {})
          params = to_query.merge(params)

          Hotel.search(params)
        end
      end

      class LargeClass < Base
      end

      class MiddleClass < Base
      end

      class SmallClass < Base
      end

      class DetailClass < Base
      end
    end
  end
end
