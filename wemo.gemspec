# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'wemo/version'

Gem::Specification.new do |spec|
  spec.name          = "wemo"
  spec.version       = Wemo::VERSION
  spec.authors       = ["Scott Ballantyne"]
  spec.email         = ["ussballantyne@gmail.com"]
  spec.description   = %q{trying to make it work}
  spec.summary       = %q{trying to make it work}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_dependency 'simple_upnp'
  spec.add_dependency 'curb'
end
