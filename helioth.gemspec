$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "helioth/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "helioth"
  s.version     = Helioth::VERSION
  s.authors     = ["Guillaume Montard"]
  s.email       = ["guillaume.montard@gmail.com"]
  s.homepage    = "https://github.com/gmontard/helioth"
  s.summary     = "Feature rollout and flipping"
  s.description = "Simple way to manage feature rollout / flipping"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.required_ruby_version = '>= 2.0'

  s.add_dependency 'activerecord', '>= 3.0'
  s.add_dependency 'i18n'

  s.add_development_dependency "rails", "~> 4.1.5"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "pry"
  s.add_development_dependency "rspec-rails", "~> 3.0.0"
  s.add_development_dependency "coveralls"
end
