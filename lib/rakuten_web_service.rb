# frozen_string_literal: true

require 'rakuten_web_service/configuration'

module RakutenWebService
  def configure(&block)
    raise ArgumentError, 'Block is required' unless block
    raise ArgumentError, 'Block is required to have one argument' if block.arity != 1
    yield configuration

    configuration
  end

  def configuration
    @configuration ||= Configuration.new
  end

  module_function :configure, :configuration
end
RWS = RakutenWebService

require 'rakuten_web_service/ichiba'
require 'rakuten_web_service/books'
require 'rakuten_web_service/travel'
require 'rakuten_web_service/kobo'
require 'rakuten_web_service/gora'
require 'rakuten_web_service/recipe'
