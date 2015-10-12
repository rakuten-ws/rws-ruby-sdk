require 'rspec'
require 'webmock/rspec'
require 'tapp'

if ENV['CODECLIMATE_REPO_TOKEN']
  require 'codeclimate-test-reporter'
  CodeClimate::TestReporter.start
end

$: << File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))

Dir[File.expand_path(File.join(File.dirname(__FILE__), "support/**/*.rb"))].each { |f| require f }

RSpec.configure do |c|
  c.mock_with :rspec

  c.before :all do
    WebMock.disable_net_connect!(:allow => "codeclimate.com")
  end

  c.after :each do
    WebMock.reset!
  end
end
