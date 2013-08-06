require 'rspec'
require 'webmock/rspec'

$: << File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))

RSpec.configure do |c|
  c.mock_with :rspec

  c.before :all do
    WebMock.disable_net_connect!
  end

  c.after :each do
    WebMock.reset!
  end
end
