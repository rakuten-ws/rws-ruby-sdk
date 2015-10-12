require 'rspec'
require 'webmock/rspec'
require 'tapp'

if ENV['CI']
  require 'codeclimate-test-reporter'
  CodeClimate::TestReporter.start
end

$: << File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))

Dir[File.expand_path(File.join(File.dirname(__FILE__), "support/**/*.rb"))].each { |f| require f }

RSpec.configure do |c|
  c.mock_with :rspec

  c.filter_run_excluding integration: true unless ENV['INTEGRATION']

  c.before :suite do
    WebMock.disable_net_connect!(:allow => "codeclimate.com")
  end

  c.after :each do
    WebMock.reset!
  end
end
