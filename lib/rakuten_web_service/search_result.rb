module RakutenWebService
  class SearchResult
    include Enumerable

    def initialize(params, resource_class, client)
      @params = params
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
      if options.is_a? Hash
        key, sort_order = *(options.to_a.last)
        key = key.to_s.camelize(:lower)
        @params[:sort] = case sort_order.to_s.downcase
                         when 'desc'
                           "-#{key}"
                         when 'asc'
                           "+#{key}"
                         end
      elsif options.to_s == 'standard'
        @params[:sort] = 'standard' 
      else 
        raise ArgumentError, "Invalid Sort Option: #{options.inspect}"
      end
      self
    end

    private
    def query(params=nil)
      @client.get(params || @params)
    end
  end
end
