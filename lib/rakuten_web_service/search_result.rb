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

          if response.body['page'] < response.body['pageCount']
            response = query(params.merge('page' => response.body['page'] + 1))
          else 
            response = nil
          end
        end while(response) 
      end
    end

    private
    def query(params=nil)
      @client.get(params || @params)
    end
  end
end
