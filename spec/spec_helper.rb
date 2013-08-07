require 'rspec'
require 'webmock/rspec'
require 'tapp'

$: << File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))

Dir[File.expand_path(File.join(File.dirname(__FILE__), "support/**/*.rb"))].each { |f| require f }

RSpec.configure do |c|
  c.mock_with :rspec

  c.before :all do
    WebMock.disable_net_connect!
  end

  c.after :each do
    WebMock.reset!
  end
end
