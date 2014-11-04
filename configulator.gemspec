# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'configulator/version'

Gem::Specification.new do |spec|
  spec.name          = "configulator"
  spec.version       = Configulator::VERSION
  spec.authors       = ["Brian Muller"]
  spec.email         = ["bamuller@gmail.com"]
  spec.summary       = %q{Generate config files from a template}
  spec.description   = %q{Generate config files from a template}
  spec.homepage      = "http://github.com/bmuller/configulator"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rdoc"
end
