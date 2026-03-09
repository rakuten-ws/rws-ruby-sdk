# frozen_string_literal: true

module RakutenWebService
  class Error < StandardError
    def self.register(status_code, error)
      repository[status_code] = error
    end

    def self.for(response)
      error_class = repository[response.code.to_i]
      json_body = JSON.parse(response.body)
      # Note: In some case (e.g. authentication info missing), the server returns another format of error response like following:
      #       {"errors"=>{"errorCode"=>400, "errorMessage"=>"accessKey must be present as a query parameter or in the header"}}
      error_class.new(json_body['error_description'] || json_body.dig('errors', 'errorMessage'))
    end

    def self.repository
      @repository ||= {}
    end
  end

  class WrongParameter < Error; end
  Error.register(400, WrongParameter)

  class NotFound < Error; end
  Error.register(404, NotFound)

  class TooManyRequests < Error; end
  Error.register(429, TooManyRequests)

  class SystemError < Error; end
  Error.register(500, SystemError)

  class ServiceUnavailable < Error; end
  Error.register(503, ServiceUnavailable)
end
