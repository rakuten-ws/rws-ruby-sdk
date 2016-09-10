module RakutenWebService
  class Error < StandardError
  end

  class WrongParameter < Error; end
  class NotFound < Error; end
  class TooManyRequests < Error; end
  class SystemError < Error; end
  class ServiceUnavailable < Error; end
end
