module RakutenWebService
  class SearchResult
    include Enumerable

    def initialize(params, resource_class, client)
      @params = params.dup
      @resource_class = resource_class
      @client = client
    end

    def each
      if @results 
        @results.each do |item|
          yield item
        end
      else
        @results = []
        params = @params
        response = query
        begin
          resources = @resource_class.parse_response(response.body)
          resources.each do |resource|
            yield resource
            @results << resource
          end

          if response.body['page'] && response.body['page'] < response.body['pageCount']
            response = query(params.merge('page' => response.body['page'] + 1))
          else 
            response = nil
          end
        end while(response) 
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
      self.class.new(new_params, @resource_class, @client)
    end

    private
    def query(params=nil)
      @client.get(params || @params)
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
