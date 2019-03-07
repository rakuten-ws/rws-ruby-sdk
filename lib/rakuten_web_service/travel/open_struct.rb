module RakutenWebService
  module Travel
    class OpenStruct
      using RakutenWebService::StringSupport

      def initialize(hash)
        @table = {}
        hash.each do |(key, val)|
          val = self.class.new(val) if val.is_a?(Hash)
          val = val.map { |v| self.class.new(v) } if val.is_a?(Array)
          name = key.to_sym
          @table[name] = val
          define_singleton_method(name) { @table[name] }
          define_singleton_method(name.to_s.to_snake) { @table[name] }
        end
      end
    end
  end
end
