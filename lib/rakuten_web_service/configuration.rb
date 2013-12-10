module RakutenWebService
  class Configuration
    attr_accessor :application_id, :affiliate_id, :max_retries

    def initialize
      @max_retries = 5
    end

    def generate_parameters
      { :application_id => application_id, :affiliate_id => affiliate_id }
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
