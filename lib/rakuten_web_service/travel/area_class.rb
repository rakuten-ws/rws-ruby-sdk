require 'rakuten_web_service/resource'

module RakutenWebService
  module Travel
    module AreaClass
      class Base < RakutenWebService::Resource
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
        end

        attr_reader :parent, :children

        def initialize(data, parent=nil)
          @parent = parent
          @params, @children = *(case class_data = data["#{self.class.area_level}Class"]
                              when Array
                                class_data.first(2)
                              when Hash
                                [class_data, nil]
                              end)

          if not(children.nil?) and not(children.empty?)
            children_class = children.keys.map { |k| k[/\A(\w*)Classes\Z/, 1] }.first rescue data.tapp
            @params["#{children_class}Classes"] = children["#{children_class}Classes"].map do |child_data|
              Base.area_classes[children_class].new(child_data, self)
            end
            @children = @params["#{children_class}Classes"]
          else
            @children = []
          end
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

      def search(options={})
        Base.search(options)
      end
      module_function :search
    end
  end
end
