if ENV['CI']
  require 'codeclimate-test-reporter'
  CodeClimate::TestReporter.start

  require 'coveralls'
  Coveralls.wear!
end

require File.expand_path(File.join(__dir__, '..', 'lib', 'rakuten_web_service'))

require 'webmock/rspec'

Dir[File.expand_path(File.join(File.dirname(__FILE__), "support/**/*.rb"))].each { |f| require f }

RSpec.configure do |c|
  c.mock_with :rspec

  c.filter_run_excluding integration: true unless ENV['INTEGRATION']

  c.before :suite do
    WebMock.disable_net_connect!(:allow => "codeclimate.com")
  end

  c.before :suite, integration: true do
    WebMock.allow_net_connect!
  end

  c.after :each do
    WebMock.reset!
  end
end
