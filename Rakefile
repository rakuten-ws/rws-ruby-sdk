require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

task :endpoints do
  require 'rakuten_web_service'
  require 'terminal-table'

  table = Terminal::Table.new(headings: %w[Resource Endpoint]) do |t|
    RakutenWebService::Resource.subclasses.each do |resource|
      t << [resource.name, resource.endpoint] unless resource.endpoint.nil?
    end
  end

  puts table
end

RSpec::Core::RakeTask.new do |t|
  t.pattern = 'spec/**/*_spec.rb'
  t.rspec_opts = '-c -fd'
end

task :rspec => :spec
task :default => :spec
