require 'logger'

module RakutenWebService
  class Configuration
    attr_accessor :application_id, :affiliate_id, :max_retries, :debug

    def initialize
      @max_retries = 5
    end

    def generate_parameters(params)
      convert_snake_key_to_camel_key(default_parameters.merge(params))
    end

    def default_parameters 
      { :application_id => application_id, :affiliate_id => affiliate_id }
    end

    private
    def convert_snake_key_to_camel_key(params)
      params.inject({}) do |h, (k, v)|
        k = k.to_s.gsub(/([a-z]{1})_([a-z]{1})/) { "#{$1}#{$2.capitalize}" }
        h[k] = v
        h
      end
    end
  end

  def configuration(&block)
    @configuration ||= Configuration.new
    if block
      if block.arity != 1
        raise ArgumentError, 'Block is required to have one argument' 
      end
      block.call(@configuration)
    end
    return @configuration
  end

  module_function :configuration
end
