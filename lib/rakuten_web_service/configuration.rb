module RakutenWebService
  class Configuration
    attr_accessor :application_id, :affiliate_id, :max_retries, :debug

    def initialize
      @application_id = ENV['RWS_APPLICATION_ID']
      @affiliate_id = ENV['RWS_AFFILIATE_ID']
      @max_retries = 5
    end

    def generate_parameters(params)
      convert_snake_key_to_camel_key(default_parameters.merge(params))
    end

    def default_parameters
      raise "Application ID is not defined" unless has_required_options?
      { application_id: application_id, affiliate_id: affiliate_id, format_version: '2' }
    end

    def has_required_options?
      application_id && application_id != ''
    end

    def debug_mode?
      ENV.has_key?('RWS_SDK_DEBUG') || debug
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

  def configure(&block)
    @configuration ||= Configuration.new
    if block
      if block.arity != 1
        raise ArgumentError, 'Block is required to have one argument' 
      end
      block.call(@configuration)
    end
    return @configuration
  end

  def configuration(&block)
    $stderr.puts "Warning: RakutenWebService.configuration is deprecated. Use RakutenWebService.configure." if block_given?
    self.configure(&block)
  end

  module_function :configure, :configuration
end
