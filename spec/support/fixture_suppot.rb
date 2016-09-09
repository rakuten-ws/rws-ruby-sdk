module FixtureSupport
  def fixture(path)
    fixture_path = File.expand_path(File.join(File.dirname(__FILE__), '..', 'fixtures', path))
    File.read(fixture_path)
  end
end

RSpec.configure { |c| c.include FixtureSupport }
