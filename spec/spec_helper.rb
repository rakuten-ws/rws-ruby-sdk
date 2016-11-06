if ENV['CI']
  require 'coveralls'
  Coveralls.wear!
end

require File.expand_path(File.join(__dir__, '..', 'lib', 'rakuten_web_service'))

require 'webmock/rspec'
require 'tapp'

Dir[File.expand_path(File.join(__dir__, "support/**/*.rb"))].each { |f| require f }

RSpec.configure do |c|
  c.mock_with :rspec

  c.before :suite do
    WebMock.disable_net_connect!(:allow => "codeclimate.com")
  end

  c.after :each do
    WebMock.reset!
  end
end
