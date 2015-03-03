require 'rakuten_web_service/all_proxy'

module RakutenWebService
  class SearchResult
    include Enumerable

    def initialize(params, resource_class)
      @params = params.dup
      @resource_class = resource_class
      @client = RakutenWebService::Client.new(resource_class)
    end

    def search(params)
      SearchResult.new(self.params.merge!(params), @resource_class)
    end

    def each
      query.each do |resource|
        yield resource
      end
    end

    def all(&block)
      proxy = AllProxy.new(self)
      if block
        proxy.each(&block)
      else
        return proxy
      end
    end

    def params
      return {} if @params.nil?
      @params.dup 
    end

    def order(options)
      new_params = @params.dup
      if options.is_a? Hash
        key, sort_order = *(options.to_a.last)
        key = camelize(key.to_s)
        new_params[:sort] = case sort_order.to_s.downcase
                         when 'desc'
                           "-#{key}"
                         when 'asc'
                           "+#{key}"
                         end
      elsif options.to_s == 'standard'
        new_params[:sort] = 'standard' 
      else 
        raise ArgumentError, "Invalid Sort Option: #{options.inspect}"
      end
      self.class.new(new_params, @resource_class)
    end

    def query(params=nil)
      @response = ensure_retries { @client.get(params || @params) }
    end
    alias fetch_result query

    def has_next_page?
      !@response && @response.has_next_page?
    end

    private
    def ensure_retries(max_retries=RakutenWebService.configuration.max_retries)
      begin 
        yield
      rescue RWS::TooManyRequests => e
        if max_retries > 0
          max_retries -= 1
          sleep 1
          retry
        else
          raise e
        end
      end
    end

    def camelize(str)
      str = str.downcase
      str = str.gsub(/([a-z]+)_([a-z]+)/) do
        "#{$1.capitalize}#{$2.capitalize}"
      end
      str[0] = str[0].downcase
      str
    end
  end
end
