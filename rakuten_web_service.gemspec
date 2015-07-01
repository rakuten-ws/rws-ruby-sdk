# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rakuten_web_service/version'

Gem::Specification.new do |spec|
  spec.name          = "rakuten_web_service"
  spec.version       = RakutenWebService::VERSION
  spec.authors       = ["Tatsuya Sato"]
  spec.email         = ["tatsuya.b.sato@mail.rakuten.com"]
  spec.description   = %q{Ruby Client for Rakuten Web Service}
  spec.summary       = %q{Ruby Client for Rakuten Web Service}
  spec.homepage      = "http://webservice.rakuten.co.jp/"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.required_ruby_version = '> 1.9.2'

  spec.add_dependency 'faraday', '~> 0.9.0'
  spec.add_dependency 'faraday_middleware'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "rspec", '~> 2.14.1'
  spec.add_development_dependency "tapp"
end
