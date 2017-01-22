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
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.required_ruby_version = '>= 2.1.0'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "webmock", "~> 1.20.4"
  spec.add_development_dependency "rspec", '~> 3.5.0'
  spec.add_development_dependency "tapp"
end
