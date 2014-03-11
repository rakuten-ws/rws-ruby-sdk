module RakutenWebService
  module Travel
    class OpenStruct
      include RakutenWebService::StringHelper

      def initialize(hash)
        @table = {}
        hash.keys.each do |key|
          v = hash[key].is_a?(Hash) ? self.class.new(hash[key]) : hash[key]
          name = key.to_sym
          @table[name] = v
          define_singleton_method(name) { @table[name] }
          define_singleton_method(to_snakecase(name.to_s)) { @table[name] }
        end
      end
    end
  end
end
