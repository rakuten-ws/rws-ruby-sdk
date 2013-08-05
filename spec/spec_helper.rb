require 'rspec'

$: << File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))

RSpec.configure do |c|
  c.mock_with :rspec
end
