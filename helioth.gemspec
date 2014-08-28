# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'helioth/version'

Gem::Specification.new do |spec|
  spec.name          = "helioth"
  spec.version       = Helioth::VERSION
  spec.authors       = ["Guillaume Montard"]
  spec.email         = ["guillaume.montard@vodeclic.com"]
  spec.summary       = %q{Feature rollout and flipping}
  spec.description   = %q{Simple way to manage your feature rollout for customers and users}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
